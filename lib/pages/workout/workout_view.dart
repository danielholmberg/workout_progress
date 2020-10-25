library workout_page;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../../models/workout_model.dart';
import '../../services/firebase/auth.dart';
import '../../services/util_service.dart';
import '../../shared/constants.dart';
import '../../shared/extensions.dart';
import '../../shared/snackbar.dart';
import '../../shared/widgets/custom_awesome_icon.dart';

part 'workout_view_desktop.dart';
part 'workout_view_mobile.dart';

class WorkoutView extends StatelessWidget {
  final Workout workout;
  const WorkoutView({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => _WorkoutViewMobile(workout: workout),
      desktop: (BuildContext context) => _WorkoutViewDesktop(workout: workout),
    );
  }
}
