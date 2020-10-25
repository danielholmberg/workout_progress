import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/workout_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../../locator.dart';
import '../../../router.dart';

class WorkoutsList extends StatelessWidget {
  const WorkoutsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final FirebaseFirestoreService databaseService = locator<FirebaseFirestoreService>();
    final NavigationService navigationsService = locator<NavigationService>();

    Widget _buildListItem(Workout workout) => GestureDetector(
      onTap: () => navigationsService.navigateTo(Router.workoutRoute, arguments: workout),
          child: Card(
            child: Center(
              child: Text(
                workout.name,
                textAlign: TextAlign.center,
              ),
            ),
          ),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: StreamBuilder<List<Workout>>(
        stream: databaseService.workouts,
        builder: (context, snapshot) {
          List<Workout> workoutList = snapshot.hasData ? snapshot.data : [];

          List<Widget> children = workoutList
              .map(
                (Workout workout) => _buildListItem(workout),
              )
              .toList();

          children.insert(0,
            RaisedButton.icon(
              icon: CustomAwesomeIcon(
                icon: FontAwesomeIcons.plus,
                color: Colors.white,
              ),
              onPressed: () async => await databaseService.createTestWorkout(),
              label: Text(
                'Create workout',
                style: themeData.textTheme.button,
              ),
            ),
          );

          return GridView.count(
            scrollDirection: Axis.horizontal,
            reverse: false,
            shrinkWrap: false,
            crossAxisCount: 1,
            childAspectRatio: 1.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            children: children,
          );
        },
      ),
    );
  }
}
