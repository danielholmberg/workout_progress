part of 'workout_view.dart';

class _WorkoutViewMobile extends StatelessWidget {
  final Workout workout;
  final StopWatchTimer stopWatch;
  final Function(Workout) saveWorkout;
  final Function() deleteWorkout;
  const _WorkoutViewMobile({
    Key key,
    this.workout,
    this.stopWatch,
    this.saveWorkout,
    this.deleteWorkout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDarkTheme = AdaptiveTheme.of(context).mode.isDark;

    final FirebaseAuthService authService = locator<FirebaseAuthService>();
    final FirebaseFirestoreService dbService =
        locator<FirebaseFirestoreService>();
    final NavigationService navigationService = locator<NavigationService>();
    final SnackbarService snackbarService = locator<SnackbarService>();
    final DialogService dialogService = locator<DialogService>();
    final UtilService utilService = locator<UtilService>();

    _saveWorkout() async {
      stopWatch.onExecute.add(StopWatchExecute.stop);

      await Future.forEach(
        workout.exercises,
        (exerciseId) async {
          Exercise exercise = dbService.getExercise(exerciseId);
          await dbService.saveExercise(exercise);

          // Update existing exercise sets
          await Future.forEach(exercise.sets, (exerciseSetId) async {
            if (!exercise.setsToCreate.containsKey(exerciseSetId)) {
              await dbService.saveExerciseSet(
                dbService.getExerciseSet(exerciseSetId),
              );
            }
          });

          // Create added exercise sets
          await Future.forEach(
            exercise.setsToCreate.values,
            (ExerciseSet exerciseSet) async {
              await dbService.createExerciseSet(exerciseSet);
            },
          );
        },
      );
      await saveWorkout(workout);
    }

    _buildExerciseList() {
      if (workout.exercises.length == 0) {
        return Center(
          child: Text(
            "No exercises added to this workout!",
          ),
        );
      } else {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: workout.exercises.length,
          itemBuilder: (context, index) {
            Exercise exercise = dbService.getExercise(workout.exercises[index]);
            return ExerciseItem(
              baseExercise: dbService.getBaseExercise(exercise.baseExerciseId),
              exercise: exercise,
              active: true,
            );
          },
          separatorBuilder: (context, index) => Divider(
            height: 2,
          ),
        );
      }
    }

    _buildStopWatchActions() {
      if (stopWatch.isRunning) {
        return IconButton(
          icon: CustomAwesomeIcon(
            icon: FontAwesomeIcons.pause,
            color: themeData.accentColor,
          ),
          onPressed: () {
            stopWatch.onExecute.add(StopWatchExecute.stop);
          },
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: CustomAwesomeIcon(
                icon: FontAwesomeIcons.undo,
                color: themeData.accentColor,
              ),
              onPressed: () {
                stopWatch.setPresetTime(mSec: 0);
                stopWatch.onExecute.add(StopWatchExecute.reset);
              },
            ),
            IconButton(
              icon: CustomAwesomeIcon(
                icon: FontAwesomeIcons.play,
                color: themeData.accentColor,
              ),
              onPressed: () {
                stopWatch.onExecute.add(StopWatchExecute.start);
              },
            ),
          ],
        );
      }
    }

    _deleteWorkout() async {
      await deleteWorkout();
      navigationService.back();
    }

    _buildAppBar() {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeData.backgroundColor,
        centerTitle: true,
        title: Text(
          workout.name,
          style: themeData.textTheme.headline2,
        ),
        actions: [
          IconButton(
            icon: CustomAwesomeIcon(
              icon: FontAwesomeIcons.trash,
              color: themeData.buttonColor,
            ),
            onPressed: () async {
              DialogResponse result = await dialogService.showCustomDialog(
                variant: AdaptiveTheme.of(context).mode.isDark
                    ? DialogType.CONFIRM_DARK
                    : DialogType.CONFIRM_LIGHT,
                title: "Deleting workout",
                description: "Are you sure you want to delete this workout?",
                showIconInMainButton: true,
                showIconInSecondaryButton: true,
                mainButtonTitle: "Yes",
                secondaryButtonTitle: "No",
                barrierDismissible: true,
              );

              if (result.confirmed) {
                await _deleteWorkout();
              }
            },
          ),
        ],
      );
    }

    _handleOnBackPress({bool isActionButton}) async {
      DialogResponse result = await dialogService.showCustomDialog(
        variant:
            isDarkTheme ? DialogType.CONFIRM_DARK : DialogType.CONFIRM_LIGHT,
        title: 'Discard changes?',
        description: 'Do you want to discard changes to this workout?',
        mainButtonTitle: 'Stay',
        secondaryButtonTitle: 'Discard',
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

    _buildBottomBar() {
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
          title: StreamBuilder<int>(
            initialData: stopWatch.rawTime.value,
            stream: stopWatch.rawTime,
            builder: (context, snapshot) {
              int value = snapshot.data;
              final displayTime = utilService.getDisplayTime(value);
              return Text(
                displayTime,
                style: themeData.textTheme.caption.copyWith(
                  color: stopWatch.isRunning
                      ? themeData.primaryColor
                      : themeData.disabledColor,
                ),
              );
            },
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
                onPressed: () => _saveWorkout(),
              ),
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
          child: _buildExerciseList(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: themeData.buttonColor,
          label: _buildStopWatchActions(),
          onPressed: null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }
}
