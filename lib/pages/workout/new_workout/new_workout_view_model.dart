import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/workout_model.dart';
import 'package:workout_progress/services/firebase/auth.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/services/util_service.dart';
import 'package:workout_progress/shared/dialogs.dart';

import '../../../locator.dart';

class NewWorkoutViewModel extends ReactiveViewModel {
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final FirebaseFirestoreService _dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final UtilService _utilService = locator<UtilService>();

  bool _isDarkTheme;
  Workout _newWorkout;
  List<Exercise> _addedExercises;
  Map<int, Exercise> _selectedExercises;
  FocusNode _nameFocusNode;

  void initialise(BuildContext context) {
    _isDarkTheme = AdaptiveTheme.of(context).mode.isDark;
    _newWorkout = Workout.emptyWorkout(_dbService.newWorkoutId);
    _addedExercises = [];
    _selectedExercises = new Map();
    _nameFocusNode = new FocusNode();
  }

  Workout get newWorkout => _newWorkout;
  FocusNode get nameFocusNode => _nameFocusNode;
  bool get isDarkTheme => _isDarkTheme;
  bool get hasSelectedExercises => _selectedExercises.isNotEmpty;
  bool get hasAddedExercises => _addedExercises.isNotEmpty;
  int get addedExercisesCount => _addedExercises.length;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  BaseExercise getAddedBaseExercise(int index) =>
      _dbService.getBaseExercise(_addedExercises[index].baseExerciseId);
  Exercise getAddedExercise(int index) => _addedExercises[index];

  Future addExercisesToWorkout(List<BaseExercise> selectedBaseExercises) async {
    for (BaseExercise baseExercise in selectedBaseExercises) {
      Exercise exercise = Exercise.emptyExercise(
        _dbService.newExerciseId,
        selectedBaseExercises.indexOf(baseExercise),
        _newWorkout.id,
        baseExercise.id,
      );

      // Add new Exercise to list
      _addedExercises.add(exercise);

      // Add new Exercise ID to Workout
      _newWorkout.exercises.add(exercise.id);

      // De-select the BaseExercise we just created an Exercise from.
      baseExercise.setSelected(false);
    }

    notifyListeners();
  }

  removeSelectedExercises() async {
    for (int index in _selectedExercises.keys) {
      _addedExercises.removeAt(index);
      _newWorkout.exercises.removeAt(index);
    }

    _selectedExercises.clear();

    notifyListeners();
  }

  Future<bool> onWillPop({bool isActionButton}) async {
    DialogResponse result = await _dialogService.showCustomDialog(
      variant: isDarkTheme ? DialogType.CONFIRM_DARK : DialogType.CONFIRM_LIGHT,
      title: 'Discard workout?',
      description: 'Do you want to discard this workout?',
      mainButtonTitle: 'Stay',
      secondaryButtonTitle: 'Discard workout',
    );

    if (!result.confirmed) {
      if (isActionButton) {
        _navigationService.back();
      }
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  void onDonePress() async {
    bool invalidWorkoutName = _newWorkout.name.trim().isEmpty;
    if (invalidWorkoutName) {
      await _dialogService.showCustomDialog(
        variant: isDarkTheme ? DialogType.INFO_DARK : DialogType.INFO_LIGHT,
        title: 'Invalid workout name',
        description: 'Don\'t forgett to name your workout!',
      );
      _nameFocusNode.requestFocus();
    } else {
      setBusy(true);

      // Create all new Exercises
      await _dbService.saveExercises(_addedExercises);

      // Create Workout
      await _dbService.createWorkout(
        name: _newWorkout.name,
        exercises: _newWorkout.exercises,
      );

      _navigationService.back();
    }
  }

  void onExerciseLongPress(int index) {
    Exercise exercise = _addedExercises[index];
    exercise.toggleSelected();
    if (exercise.selected) {
      _selectedExercises.update(index, (e) => exercise,
          ifAbsent: () => exercise);
    } else {
      if (_selectedExercises.containsValue(_addedExercises[index])) {
        _selectedExercises.remove(index);
      }
    }

    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authService, _dbService];
}
