part of 'new_workout_view.dart';

class _NewWorkoutViewMobile extends ViewModelWidget<NewWorkoutViewModel> {
  const _NewWorkoutViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, NewWorkoutViewModel model) {
    final ThemeData themeData = Theme.of(context);

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
          return SearchExerciseView(
            addBaseExercisesToWorkout: model.addExercisesToWorkout,
          );
        },
      );
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
            onPressed: () async => await model.removeSelectedExercises(),
            icon: CustomAwesomeIcon(
              icon: FontAwesomeIcons.trash,
              color: themeData.buttonColor,
            ),
          ).isVisible(model.hasSelectedExercises),
        ],
      );
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
            onPressed: () => model.onWillPop(isActionButton: true),
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
                onPressed: model.onDonePress,
              ).isVisible(model.hasAddedExercises),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () => model.onWillPop(isActionButton: false),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: ListView(
            children: [
              TextFormField(
                focusNode: model.nameFocusNode,
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
                initialValue: model.newWorkout.name,
                onChanged: (value) => model.newWorkout.setName(value),
                style: themeData.textTheme.headline2,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: model.addedExercisesCount,
                itemBuilder: (context, index) => ListTile(
                  onLongPress: () => model.onExerciseLongPress(index),
                  contentPadding: EdgeInsets.zero,
                  title: ExerciseItem(
                    baseExercise: model.getAddedBaseExercise(index),
                    exercise: model.getAddedExercise(index),
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
