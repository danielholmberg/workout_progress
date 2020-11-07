part of 'new_workout_view.dart';

class _NewWorkoutViewMobile extends StatefulWidget {
  const _NewWorkoutViewMobile({Key key}) : super(key: key);

  @override
  __NewWorkoutViewMobileState createState() => __NewWorkoutViewMobileState();
}

class __NewWorkoutViewMobileState extends State<_NewWorkoutViewMobile> {
  Workout newWorkout;
  List<Exercise> addedExercises;
  Map<int, Exercise> selectedExercises;
  FocusNode nameFocusNode;

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirebaseFirestoreService dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService navigationService = locator<NavigationService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final DialogService dialogService = locator<DialogService>();
  final UtilService utilService = locator<UtilService>();

  @override
  void initState() {
    super.initState();
    newWorkout = Workout.emptyWorkout(dbService.newWorkoutId);
    addedExercises = [];
    selectedExercises = new Map();
    nameFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  Future addExercisesToWorkout(List<BaseExercise> selectedBaseExercises) async {
    await Future.forEach(selectedBaseExercises,
        (BaseExercise baseExercise) async {
      print('Adding exercise: ' + baseExercise.toString());
      Exercise exercise = Exercise.emptyExercise(
        dbService.newExerciseId,
        baseExerciseId: baseExercise.id,
      );

      if (!addedExercises.contains(baseExercise)) {
        addedExercises.add(exercise);
      }

      newWorkout.exercises.add(exercise.id);
      baseExercise.setSelected(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDarkTheme = AdaptiveTheme.of(context).mode.isDark;

    _showNewExerciseModal() {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        isDismissible: true,
        builder: (context) {
          return SearchExerciseModal(
            baseExercises: dbService.getBaseExercises(),
            addBaseExercisesToWorkout: addExercisesToWorkout,
          );
        },
      );
    }

    _removeSelectedExercises() async {
      await Future.forEach(
        selectedExercises.keys.toList(),
        (int index) {
          addedExercises.removeAt(index);
        },
      );
      selectedExercises.clear();
      setState(() {});
    }

    _buildAppBar() {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeData.backgroundColor,
        centerTitle: true,
        title: Text(
          'New workout',
          style: themeData.textTheme.headline2,
        ),
        actions: [
          IconButton(
            onPressed: () async => await _removeSelectedExercises(),
            icon: CustomAwesomeIcon(
              icon: FontAwesomeIcons.trash,
              color: themeData.buttonColor,
            ),
          ).isVisible(selectedExercises.isNotEmpty),
        ],
      );
    }

    _handleOnBackPress({bool isActionButton}) async {
      DialogResponse result = await dialogService.showCustomDialog(
        variant:
            isDarkTheme ? DialogType.CONFIRM_DARK : DialogType.CONFIRM_LIGHT,
        title: 'Discard workout?',
        description: 'Do you want to discard this workout?',
        mainButtonTitle: 'Stay',
        secondaryButtonTitle: 'Discard workout',
      );

      if (!result.confirmed) {
        if (isActionButton) {
          navigationService.back();
        }
        return true;
      } else {
        return false;
      }
    }

    _buildBottomNavBar() {
      return BottomAppBar(
        color: themeData.backgroundColor,
        child: addActionBar(
          leading: IconButton(
            icon: CustomAwesomeIcon(
              icon: FontAwesomeIcons.arrowLeft,
              color: themeData.buttonColor,
            ),
            onPressed: () => _handleOnBackPress(isActionButton: true),
          ),
          trailing: ButtonBar(
            mainAxisSize: MainAxisSize.min,
            buttonPadding: EdgeInsets.zero,
            children: [
              IconButton(
                icon: CustomAwesomeIcon(
                  icon: FontAwesomeIcons.check,
                  color: themeData.buttonColor,
                ),
                onPressed: () async {
                  bool invalidWorkoutName = newWorkout.name.trim().isEmpty;
                  if (invalidWorkoutName) {
                    await dialogService.showCustomDialog(
                      variant: isDarkTheme
                          ? DialogType.INFO_DARK
                          : DialogType.INFO_LIGHT,
                      title: 'Invalid workout name',
                      description: 'Don\'t forgett to name your workout!',
                    );
                    nameFocusNode.requestFocus();
                  } else {

                    // Create all new exercises
                    await Future.forEach(
                      addedExercises,
                      (Exercise exercise) async {
                        await dbService.saveExercise(exercise);

                        // Create added exercise sets
                        await Future.forEach(
                          exercise.setsToCreate.values,
                          (ExerciseSet exerciseSet) async {
                            await dbService.createExerciseSet(exerciseSet);
                          },
                        );
                      },
                    );

                    // Finally create workout
                    await dbService.createWorkout(
                      name: newWorkout.name,
                      exercises: newWorkout.exercises,
                    );

                    navigationService.back();
                  }
                },
              ).isVisible(addedExercises.isNotEmpty),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () => _handleOnBackPress(isActionButton: false),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: ListView(
            children: [
              TextFormField(
                focusNode: nameFocusNode,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Workout name',
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(defaultPadding),
                  hintStyle: themeData.textTheme.headline2.copyWith(
                    color: themeData.hintColor,
                  ),
                ),
                initialValue: newWorkout.name,
                onChanged: (value) => newWorkout.setName(value),
                style: themeData.textTheme.headline2,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: addedExercises.length,
                itemBuilder: (context, index) => ListTile(
                  onLongPress: () {
                    Exercise exercise = addedExercises[index];
                    exercise.toggleSelected();
                    if (exercise.selected) {
                      selectedExercises.update(index, (e) => exercise,
                          ifAbsent: () => exercise);
                    } else {
                      if (selectedExercises
                          .containsValue(addedExercises[index])) {
                        selectedExercises.remove(index);
                      }
                    }
                    setState(() {});
                  },
                  contentPadding: EdgeInsets.zero,
                  title: ExerciseItem(
                    baseExercise: dbService.getBaseExercise(
                      addedExercises[index].baseExerciseId,
                    ),
                    exercise: addedExercises[index],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: themeData.buttonColor,
          onPressed: () => _showNewExerciseModal(),
          icon: CustomAwesomeIcon(
            icon: FontAwesomeIcons.plus,
            color: themeData.accentColor,
          ),
          label: Text(
            'Add exercise',
            style: themeData.textTheme.button,
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }
}
