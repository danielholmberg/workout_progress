import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/workout_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/services/util_service.dart';

import '../../../locator.dart';
import '../../../router.dart';

class WorkoutsViewModel extends ReactiveViewModel {
  final FirebaseFirestoreService _dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService _navigationsService = locator<NavigationService>();
  final UtilService _utilService = locator<UtilService>();

  String getDuration(int duration) => _utilService.getDisplayTime(duration);

  void navigateToWorkout(Workout workout) => _navigationsService.navigateTo(
        MyRouter.workoutRoute,
        arguments: workout,
      );

  List<Workout> getAllWorkouts() => _dbService.getAllWorkouts();

  Exercise getExercise(String exerciseId) => _dbService.getExercise(exerciseId);

  BaseExercise getBaseExercise(String baseExerciseId) => _dbService.getBaseExercise(baseExerciseId);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_dbService];
}
