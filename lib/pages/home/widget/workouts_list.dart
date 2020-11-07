import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/workout_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../../locator.dart';
import '../../../router.dart';
import '../../../shared/extensions.dart';

class WorkoutsList extends StatelessWidget {
  const WorkoutsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final NavigationService navigationsService = locator<NavigationService>();

    Widget _buildWorkoutItem(Workout workout) {
      return Card(
        elevation: 4.0,
        child: Consumer<FirebaseFirestoreService>(
          builder: (context, dbService, child) => ExpansionTile(
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
                      onPressed: () => navigationsService.navigateTo(
                        Router.workoutRoute,
                        arguments: workout,
                      ),
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
                  workout.duration.toString(),
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
                Exercise exercise = dbService.getExercise(
                  workout.exercises[index],
                );
                BaseExercise baseExercise =
                    dbService.getBaseExercise(exercise.baseExerciseId);
                return ListTile(
                  title: Text(baseExercise.name),
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
        ),
      );
    }

    return Consumer<FirebaseFirestoreService>(
      builder: (context, dbService, child) {
        return Container(
          child: ListView.builder(
            reverse: false,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: dbService.getAllWorkouts().length,
            itemBuilder: (context, index) => _buildWorkoutItem(
              dbService.getAllWorkouts()[index],
            ),
          ),
        );
      },
    );
  }
}
