import 'package:workout_progress/services/firebase/firestore.dart';

import '../locator.dart';

class WorkoutService {

  FirebaseFirestoreService _databaseService = locator<FirebaseFirestoreService>();

  addWorkout() {
    print('Add workout');
  }

  removeWorkout() {
    print('Remove workout');
  }

  updateWorkout() {
    print("Update workout");
  }

  //Stream<List<Workout>> get scheduledWorkouts => _databaseService.scheduledWorkouts;
}