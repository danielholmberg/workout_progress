import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/exercise_set_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/services/util_service.dart';

import '../../../../locator.dart';

class ExerciseItemViewModel extends ReactiveViewModel {
  final FirebaseFirestoreService dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService navigationService = locator<NavigationService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final DialogService dialogService = locator<DialogService>();
  final UtilService utilService = locator<UtilService>();

  List<ExerciseSet> _existingExerciseSets;
  List<ExerciseSet> _addedExerciseSets;
  Exercise _exercise;

  void initialise(Exercise exercise, bool active) {
    _exercise = exercise;
    _existingExerciseSets =
        active ? dbService.getAllExerciseSets(exercise.id) : [];
    _addedExerciseSets = [];
  }

  int get exerciseSetsCount =>
      _existingExerciseSets.length + _addedExerciseSets.length;

  ExerciseSet getExerciseSet(int index) {
    return index < _existingExerciseSets.length
        ? _existingExerciseSets[index]
        : _addedExerciseSets[index - _existingExerciseSets.length];
  }

  void addExerciseSet() {
    ExerciseSet newSet = ExerciseSet.emptySet(
      dbService.newExerciseSetId,
      _exercise.id,
      _exercise.baseExerciseId,
      _exercise.workoutId,
      _existingExerciseSets.length + _addedExerciseSets.length,
    );
    _exercise.setsToCreate
        .update(newSet.id, (es) => newSet, ifAbsent: () => newSet);
    print('setToCreate After: ' + _exercise.setsToCreate.toString());
    _exercise.sets.add(newSet.id);
    _addedExerciseSets.add(newSet);
    notifyListeners();
  }

  void removeExerciseSet(int index, ExerciseSet setItem) {
    _exercise.sets.removeAt(index);
    _exercise.setsToCreate.remove(setItem.id);
    _addedExerciseSets.removeAt(index);
    notifyListeners();
  }

  void toggleCompletedExerciseSet(ExerciseSet completedSet) {
    completedSet.toggleCompleted();
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
