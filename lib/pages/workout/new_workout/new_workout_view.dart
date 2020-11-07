library new_workout_page;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/exercise_set_model.dart';
import 'package:workout_progress/models/workout_model.dart';
import 'package:workout_progress/pages/workout/new_workout/widgets/exercise_item.dart';
import 'package:workout_progress/pages/workout/new_workout/widgets/search_exercise_modal.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/dialogs.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../../locator.dart';
import '../../../services/firebase/auth.dart';
import '../../../services/firebase/firestore.dart';
import '../../../services/util_service.dart';
import '../../../shared/extensions.dart';

part 'new_workout_view_mobile.dart';

class NewWorkoutView extends StatelessWidget {
  const NewWorkoutView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => _NewWorkoutViewMobile(),
      //desktop: (BuildContext context) => _NewWorkoutViewDesktop(),
    );
  }
}