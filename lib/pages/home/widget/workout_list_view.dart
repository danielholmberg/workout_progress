import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/workout_model.dart';
import 'package:workout_progress/pages/home/widget/workout_list_view_model.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../../shared/extensions.dart';

class WorkoutList extends ViewModelWidget<WorkoutsViewModel> {
  const WorkoutList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WorkoutsViewModel model) {
    final ThemeData themeData = Theme.of(context);

    Widget _buildWorkoutItem(Workout workout) {
      return Card(
        elevation: 4.0,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          trailing: ButtonBar(
            mainAxisSize: MainAxisSize.min,
            buttonPadding: EdgeInsets.zero,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton.icon(
                    color: themeData.buttonColor,
                    padding: const EdgeInsets.all(
                      defaultPadding,
                    ),
                    icon: CustomAwesomeIcon(
                      icon: FontAwesomeIcons.play,
                      color: themeData.accentColor,
                      size: 14,
                    ),
                    label: Text(
                      'Start',
                      style: themeData.textTheme.button.copyWith(
                        color: themeData.accentColor,
                      ),
                    ),
                    onPressed: () => model.navigateToWorkout(workout),
                  ),
                ],
              ),
            ],
          ),
          title: Text(
            workout.name,
            style: themeData.textTheme.headline3,
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                model.getDuration(workout.duration),
                style: themeData.textTheme.subtitle1,
              ).withIcon(
                CustomAwesomeIcon(
                  icon: FontAwesomeIcons.stopwatch,
                  color: themeData.buttonColor,
                  size: 14.0,
                ),
              ),
              Text(
                "   |   ",
                style: themeData.textTheme.headline3,
              ),
              Text(
                workout.totalVolume.toString() + " kg",
                style: themeData.textTheme.subtitle1,
              ).withIcon(
                CustomAwesomeIcon(
                  icon: FontAwesomeIcons.dumbbell,
                  color: themeData.buttonColor,
                  size: 14.0,
                ),
              ),
              Text(
                "   |   ",
                style: themeData.textTheme.headline3,
              ),
              Text(
                DateFormat.yMMMd().format(workout.startTimeAndDate.toDate()),
                style: themeData.textTheme.subtitle1,
              ).withIcon(
                CustomAwesomeIcon(
                  icon: FontAwesomeIcons.calendar,
                  color: themeData.buttonColor,
                  size: 14.0,
                ),
              ),
            ],
          ),
          children: List.generate(
            workout.exercises.length,
            (index) {
              Exercise exercise = model.getExercise(workout.exercises[index]);
              return ListTile(
                title: Text(
                  model.getBaseExercise(exercise.baseExerciseId).name,
                ),
                subtitle: Text(exercise.sets.length.toString()),
                trailing: ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  buttonPadding: EdgeInsets.zero,
                  children: [
                    CustomAwesomeIcon(
                      icon: FontAwesomeIcons.weight,
                      color: themeData.buttonColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      child: ListView.builder(
        reverse: false,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: model.getAllWorkouts().length,
        itemBuilder: (context, index) => _buildWorkoutItem(
          model.getAllWorkouts()[index],
        ),
      ),
    );
  }
}
