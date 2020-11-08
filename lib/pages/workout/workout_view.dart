library workout_page;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/exercise_set_model.dart';
import 'package:workout_progress/pages/workout/new_workout/widgets/exercise_item_view.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/shared/dialogs.dart';

import '../../locator.dart';
import '../../models/workout_model.dart';
import '../../services/firebase/auth.dart';
import '../../services/util_service.dart';
import '../../shared/constants.dart';
import '../../shared/extensions.dart';
import '../../shared/snackbar.dart';
import '../../shared/widgets/custom_awesome_icon.dart';

part 'workout_view_[desktop].dart';
part 'workout_view_[mobile].dart';

class WorkoutView extends StatefulWidget {
  final Workout workout;
  const WorkoutView({Key key, this.workout}) : super(key: key);

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  StopWatchTimer stopWatch;
  bool started = false;
  bool deleted = false;
  ThemeData themeData;

  final FirebaseFirestoreService dbService =
      locator<FirebaseFirestoreService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final UtilService utilService = locator<UtilService>();

  @override
  void initState() {
    super.initState();
    stopWatch = new StopWatchTimer(onChange: (int value) {
      widget.workout.setCurrentTime(value);
      setState(() {});
    });
    stopWatch.setPresetTime(mSec: widget.workout.currentTime);
  }

  @override
  void dispose() async {
    super.dispose();
    await stopWatch.dispose();
    if (!deleted) await saveWorkout(widget.workout);
  }

  Future saveWorkout(Workout updatedWorkout) async {
    await dbService.saveWorkout(updatedWorkout);
    if (mounted) {
      setState(() {});
      snackbarService.showCustomSnackBar(
        variant: themeData.brightness == Brightness.dark
            ? SnackbarType.DARK_TOP
            : SnackbarType.LIGHT_TOP,
        message:
            'Good job finishing the workout!\nTotal time: ${utilService.getDisplayTime(updatedWorkout.currentTime)}',
        title: 'Workout saved',
        duration: Duration(seconds: 2),
      );
    }
  }

  Future deleteWorkout() async {
    await dbService.deleteWorkout(widget.workout);
    if (mounted) {
      setState(() {
        deleted = true;
      });
      snackbarService.showCustomSnackBar(
        variant: themeData.brightness == Brightness.dark
            ? SnackbarType.DARK_BOTTOM
            : SnackbarType.LIGHT_BOTTOM,
        title: 'Deleted workout',
        message: widget.workout.name,
        duration: Duration(seconds: 1),
        mainButtonTitle: 'Undo',
        onMainButtonTapped: () async => await saveWorkout(widget.workout),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => _WorkoutViewMobile(
        workout: widget.workout,
        stopWatch: stopWatch,
        saveWorkout: saveWorkout,
        deleteWorkout: deleteWorkout,
      ),
      desktop: (BuildContext context) => _WorkoutViewDesktop(
        workout: widget.workout,
        stopWatch: stopWatch,
      ),
    );
  }
}
