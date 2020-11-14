import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/exercise_set_model.dart';
import 'package:workout_progress/models/workout_model.dart';
import 'package:workout_progress/services/firebase/auth.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/services/util_service.dart';
import 'package:workout_progress/shared/dialogs.dart';
import 'package:workout_progress/shared/snackbar.dart';

import '../../locator.dart';

class WorkoutViewModel extends ReactiveViewModel {
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirebaseFirestoreService _dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final UtilService _utilService = locator<UtilService>();

  BuildContext _context;
  Workout _workout;
  StopWatchTimer _stopWatch;
  bool started = false;
  bool deleted = false;

  void initialise(BuildContext context, Workout workout) {
    _context = context;
    _workout = workout;
    _stopWatch = new StopWatchTimer(onChange: (int value) {
      _workout.setCurrentTime(value);
    });
    _stopWatch.setPresetTime(mSec: _workout.currentTime);
  }

  @override
  void dispose() async {
    await _stopWatch.dispose();
    super.dispose();
  }

  bool get isDarkTheme => AdaptiveTheme.of(_context).mode.isDark;
  bool get isRunning => _stopWatch.isRunning;
  int get exercisesCount => _workout.exercises.length;
  Workout get workout => _workout;
  int get initialTime => _stopWatch.rawTime.value;
  Stream<int> get stopWatchStream => _stopWatch.rawTime;
  bool get hasExercises => _workout.exercises.isNotEmpty;
  bool get hasNotBeenStarted => _workout.currentTime.compareTo(0) == 0;

  saveWorkout() async {
    _stopWatch.onExecute.add(StopWatchExecute.stop);
    notifyListeners();

    await Future.forEach(
      _workout.exercises,
      (exerciseId) async {
        Exercise exercise = _dbService.getExercise(exerciseId);
        await _dbService.saveExercise(exercise);

        // Update existing exercise sets
        await Future.forEach(exercise.sets, (exerciseSetId) async {
          if (!exercise.setsToCreate.containsKey(exerciseSetId)) {
            await _dbService.saveExerciseSet(
              _dbService.getExerciseSet(exerciseSetId),
            );
          }
        });

        // Create added exercise sets
        await Future.forEach(
          exercise.setsToCreate.values,
          (ExerciseSet exerciseSet) async {
            await _dbService.createExerciseSet(exerciseSet);
            exercise.setsToCreate.remove(exerciseSet.id);
          },
        );
      },
    );

    await _dbService.saveWorkout(_workout);

    _snackbarService.showCustomSnackBar(
      variant: isDarkTheme ? SnackbarType.DARK_TOP : SnackbarType.LIGHT_TOP,
      message:
          'Good job finishing the workout!\nTotal time: ${_utilService.getDisplayTime(_workout.currentTime)}',
      title: 'Workout saved',
      duration: Duration(seconds: 2),
    );

    notifyListeners();
  }

  Future _deleteWorkout() async {
    await _dbService.deleteWorkout(_workout);
    deleted = true;

    _snackbarService.showCustomSnackBar(
      variant:
          isDarkTheme ? SnackbarType.DARK_BOTTOM : SnackbarType.LIGHT_BOTTOM,
      title: 'Deleted workout',
      message: _workout.name,
      duration: Duration(seconds: 1),
      mainButtonTitle: 'Undo',
      onMainButtonTapped: () async => await saveWorkout(),
    );
    notifyListeners();

    _navigationService.back();
  }

  Exercise getExercise(int index) =>
      _dbService.getExercise(_workout.exercises[index]);

  BaseExercise getBaseExercise(String baseExerciseId) =>
      _dbService.getBaseExercise(baseExerciseId);

  void onDeleteWorkoutPress() async {
    DialogResponse result = await _dialogService.showCustomDialog(
      variant: isDarkTheme ? DialogType.CONFIRM_DARK : DialogType.CONFIRM_LIGHT,
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
  }

  onBackPress({bool isActionButton}) async {
    DialogResponse result = await _dialogService.showCustomDialog(
      variant: isDarkTheme ? DialogType.CONFIRM_DARK : DialogType.CONFIRM_LIGHT,
      title: 'Discard changes?',
      description: 'Do you want to discard changes to this workout?',
      mainButtonTitle: 'Stay',
      secondaryButtonTitle: 'Discard',
    );

    if (!result.confirmed) {
      if (isActionButton) {
        _navigationService.back();
      }
      return true;
    } else {
      return false;
    }
  }

  String getDisplayTime(int value) => _utilService.getDisplayTime(value);

  void onPausePress() {
    _stopWatch.onExecute.add(StopWatchExecute.stop);
    notifyListeners();
  }

  void onRestartPress() {
    _stopWatch.setPresetTime(mSec: 0);
    _stopWatch.onExecute.add(StopWatchExecute.reset);
    notifyListeners();
  }

  void onStartPress() {
    _stopWatch.onExecute.add(StopWatchExecute.start);
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_dbService, _utilService];
}
