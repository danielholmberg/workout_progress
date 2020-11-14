part of 'workout_view.dart';

class _WorkoutViewMobile extends ViewModelWidget<WorkoutViewModel> {
  const _WorkoutViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WorkoutViewModel model) {
    final ThemeData themeData = Theme.of(context);

    _buildExerciseList() {
      if (model.hasExercises) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: model.exercisesCount,
          itemBuilder: (context, index) {
            Exercise exercise = model.getExercise(index);
            return ExerciseItem(
              baseExercise: model.getBaseExercise(exercise.baseExerciseId),
              exercise: exercise,
              active: true,
            );
          },
          separatorBuilder: (context, index) => Divider(
            height: 2,
          ),
        );
      } else {
        return Center(
          child: Text(
            "No exercises added to this workout!",
          ),
        );
      }
    }

    _buildStopWatchActions() {
      if (model.isRunning) {
        return IconButton(
          icon: CustomAwesomeIcon(
            icon: FontAwesomeIcons.pause,
            color: themeData.accentColor,
          ),
          onPressed: model.onPausePress,
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: !model.hasNotBeenStarted,
              child: IconButton(
                icon: CustomAwesomeIcon(
                  icon: FontAwesomeIcons.undo,
                  color: themeData.accentColor,
                ),
                onPressed: model.onRestartPress,
              ),
            ),
            IconButton(
              icon: CustomAwesomeIcon(
                icon: FontAwesomeIcons.play,
                color: themeData.accentColor,
              ),
              onPressed: model.onStartPress,
            ),
          ],
        );
      }
    }

    _buildAppBar() {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeData.backgroundColor,
        centerTitle: true,
        title: Text(
          model.workout.name,
          style: themeData.textTheme.headline2,
        ),
        actions: [
          IconButton(
            icon: CustomAwesomeIcon(
              icon: FontAwesomeIcons.trash,
              color: themeData.buttonColor,
            ),
            onPressed: model.onDeleteWorkoutPress,
          ),
        ],
      );
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
            onPressed: () => model.onBackPress(isActionButton: true),
          ),
          title: StreamBuilder<int>(
            initialData: model.initialTime,
            stream: model.stopWatchStream,
            builder: (context, snapshot) {
              int value = snapshot.data;
              final String displayTime = model.getDisplayTime(value);
              return Text(
                displayTime,
                style: themeData.textTheme.caption.copyWith(
                  color: model.isRunning
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
                onPressed: model.saveWorkout,
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () => model.onBackPress(isActionButton: false),
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
