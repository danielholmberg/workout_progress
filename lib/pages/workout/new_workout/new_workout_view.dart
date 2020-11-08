library new_workout_page;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/pages/workout/new_workout/new_workout_view_model.dart';
import 'package:workout_progress/pages/workout/new_workout/widgets/exercise_item_view.dart';
import 'package:workout_progress/pages/workout/new_workout/widgets/search_exercise_view.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../../shared/extensions.dart';

part 'new_workout_view_[mobile].dart';

class NewWorkoutView extends StatelessWidget {
  const NewWorkoutView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => NewWorkoutViewModel(),
      onModelReady: (model) => model.initialise(context),
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => _NewWorkoutViewMobile(),
          //desktop: (BuildContext context) => _NewWorkoutViewDesktop(),
        );
      },
    );
  }
}
