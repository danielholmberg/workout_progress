library workout_view;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/pages/workout/new_workout/widgets/exercise_item_view.dart';
import 'package:workout_progress/pages/workout/workout_view_model.dart';

import '../../models/workout_model.dart';
import '../../shared/constants.dart';
import '../../shared/extensions.dart';
import '../../shared/widgets/custom_awesome_icon.dart';

part 'workout_view_[desktop].dart';
part 'workout_view_[mobile].dart';

class WorkoutView extends StatelessWidget {
  final Workout workout;
  const WorkoutView({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WorkoutViewModel>.reactive(
      viewModelBuilder: () => WorkoutViewModel(),
      onModelReady: (model) => model.initialise(context, workout),
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => _WorkoutViewMobile(),
          desktop: (BuildContext context) => _WorkoutViewDesktop(),
        ).isBusy(model.isBusy, Theme.of(context));
      },
    );
  }
}
