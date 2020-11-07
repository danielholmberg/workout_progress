import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/services/firebase/auth.dart';

import '../../locator.dart';
import '../../models/exercise_model.dart';
import '../../models/exercise_set_model.dart';
import '../../models/workout_model.dart';

class FirebaseFirestoreService extends ChangeNotifier {
  final FirebaseAuthService authService = locator<FirebaseAuthService>();

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference baseExercisesRef =
      FirebaseFirestore.instance.collection('available_exercises');

  StreamSubscription baseExercisesStreamSub;
  StreamSubscription workoutsStreamSub;
  StreamSubscription exercisesStreamSub;
  StreamSubscription exerciseSetsStreamSub;

  final Map<String, BaseExercise> baseExercises =
      new Map<String, BaseExercise>();
  final Map<String, Workout> workouts = new Map<String, Workout>();
  final Map<String, Exercise> exercises = new Map<String, Exercise>();
  final Map<String, ExerciseSet> exerciseSets = new Map<String, ExerciseSet>();

  // User related
  CollectionReference get workoutsRef =>
      usersRef.doc(authService.currentUser.id).collection('workouts');
  CollectionReference get exercisesRef =>
      usersRef.doc(authService.currentUser.id).collection('exercises');
  CollectionReference get setsRef =>
      usersRef.doc(authService.currentUser.id).collection('sets');
  CollectionReference get musclesRef =>
      usersRef.doc(authService.currentUser.id).collection('muscles');
  CollectionReference get bodyPartsRef =>
      usersRef.doc(authService.currentUser.id).collection('body_parts');

  String get newWorkoutId => workoutsRef.doc().id;
  String get newExerciseId => exercisesRef.doc().id;
  String get newExerciseSetId => setsRef.doc().id;

  StreamSubscription get baseExercisesStream => this.baseExercisesStreamSub;
  StreamSubscription get workoutsStream => this.workoutsStreamSub;
  StreamSubscription get exercisesStream => this.exercisesStreamSub;
  StreamSubscription get exerciseSetsStream => this.exerciseSetsStreamSub;

  cancelListeners() {
    print('Cancelling listeners...');
    baseExercisesStreamSub.cancel();
    workoutsStreamSub.cancel();
    exercisesStreamSub.cancel();
    exerciseSetsStreamSub.cancel();
    print('Success!');
  }

  setUpListeners() {
    print('Setting up listeners...');
    baseExercisesStreamSub = baseExercisesRef.snapshots().listen((event) {
      event.docChanges.forEach((docChange) {
        BaseExercise baseExercise = BaseExercise.fromSnapshot(docChange.doc);
        if (docChange.type == DocumentChangeType.removed) {
          print('Base Exercise (${baseExercise.id})[${baseExercise.name}] removed!');
          if (baseExercises.containsKey(baseExercise.id)) {
            baseExercises.remove(baseExercise.id);
          }
        } else {
          if (docChange.type == DocumentChangeType.modified)
            print('Base Exercise (${baseExercise.id})[${baseExercise.name}] modified!');
          if (docChange.type == DocumentChangeType.added)
            print('Base Exercise (${baseExercise.id})[${baseExercise.name}] added!');

          baseExercises.update(baseExercise.id, (be) => baseExercise,
              ifAbsent: () => baseExercise);
        }
        notifyListeners();
      });
    });
    workoutsStreamSub = workoutsRef.snapshots().listen((event) {
      event.docChanges.forEach((docChange) {
        Workout workout = Workout.fromSnapshot(docChange.doc);
        if (docChange.type == DocumentChangeType.removed) {
          print('Base Exercise (${workout.id})[${workout.name}] removed!');
          if (workouts.containsKey(workout.id)) {
            workouts.remove(workout.id);
          }
        } else {
          if (docChange.type == DocumentChangeType.modified)
            print('Workout (${workout.id})[${workout.name}] modified!');
          if (docChange.type == DocumentChangeType.added)
            print('Workout (${workout.id})[${workout.name}] added!');

          workouts.update(workout.id, (w) => workout, ifAbsent: () => workout);
        }
        notifyListeners();
      });
    });
    exercisesStreamSub = exercisesRef.snapshots().listen((event) {
      event.docChanges.forEach((docChange) {
        Exercise exercise = Exercise.fromSnapshot(docChange.doc);
        if (docChange.type == DocumentChangeType.removed) {
          print('Exercise (${exercise.id}) removed!');
          if (exercises.containsKey(exercise.id)) {
            exercises.remove(exercise.id);
          }
        } else {
          if (docChange.type == DocumentChangeType.modified)
            print('Exercise (${exercise.id}) modified!');
          if (docChange.type == DocumentChangeType.added)
            print('Exercise (${exercise.id}) added!');

          exercises.update(exercise.id, (e) => exercise,
              ifAbsent: () => exercise);
        }
        notifyListeners();
      });
    });
    exerciseSetsStreamSub = setsRef.snapshots().listen((event) {
      event.docChanges.forEach((docChange) {
        ExerciseSet exerciseSet = ExerciseSet.fromSnapshot(docChange.doc);
        if (docChange.type == DocumentChangeType.removed) {
          print('Exercise Set (${exerciseSet.id}) removed!');
          if (exerciseSets.containsKey(exerciseSet.id)) {
            exerciseSets.remove(exerciseSet.id);
          }
        } else {
          if (docChange.type == DocumentChangeType.modified)
            print('Exercise Set (${exerciseSet.id})[${exerciseSet.exerciseId}] modified!');
          if (docChange.type == DocumentChangeType.added)
            print('Exercise Set (${exerciseSet.id})[${exerciseSet.exerciseId}] added!');
            
          exerciseSets.update(exerciseSet.id, (es) => exerciseSet,
              ifAbsent: () => exerciseSet);
        }
        notifyListeners();
      });
    });
    print('Success!');
  }

  // --------------- BaseExercise ---------------

  List<BaseExercise> getBaseExercises() {
    return baseExercises.values.toList();
  }

  BaseExercise getBaseExercise(String id) {
    return baseExercises[id];
  }

  // --------------- Workout ---------------

  Future createWorkout({
    String name,
    List<String> exercises,
  }) {
    String id = newWorkoutId;
    return workoutsRef.doc(id).set({
      Workout.idKey: id,
      Workout.nameKey: name,
      Workout.exercisesKey: exercises,
      Workout.startTimeAndDateKey: FieldValue.serverTimestamp(),
      Workout.createdKey: FieldValue.serverTimestamp(),
    });
  }

  Future saveWorkout(Workout workout) {
    return workoutsRef.doc(workout.id).set(workout.toDocument());
  }

  Future deleteWorkout(Workout workout) {
    return workoutsRef.doc(workout.id).delete();
  }

  List<Workout> getAllWorkouts() {
    return workouts.values.toList();
  }

  Workout getWorkout(String id) {
    return workouts[id];
  }

  // --------------- Exercise ---------------

  Future createExercise(Exercise newExercise) {
    return exercisesRef.doc(newExercise.id).set(newExercise.toDocument());
  }

  Future saveExercise(Exercise exercise) {
    return exercisesRef.doc(exercise.id).set(exercise.toDocument());
  }

  List<Exercise> getAllExercises() {
    return exercises.values.toList();
  }

  /* List<Exercise> getAllExercisesForWorkout(String id) {
    List<Exercise> workoutExercises = [];
    workouts[id].exercises.forEach((exerciseId) {
      workoutExercises.add(getExercise(exerciseId));
    });
    return workoutExercises;
  } */

  Exercise getExercise(String id) {
    return exercises[id];
  }

  // --------------- ExerciseSet ---------------

  Future createExerciseSet(ExerciseSet exerciseSet) {
    return setsRef.doc(exerciseSet.id).set(exerciseSet.toDocument());
  }

  Future saveExerciseSet(ExerciseSet exerciseSet) {
    return setsRef.doc(exerciseSet.id).set(exerciseSet.toDocument());
  }

  List<ExerciseSet> getAllExerciseSets(String exerciseId) {
    return exerciseSets.values
        .toList()
        .where((ExerciseSet exerciseSet) =>
            exerciseSet.exerciseId.compareTo(exerciseId) == 0)
        .toList();
  }

  /* List<ExerciseSet> getAllExerciseSetsForExercise(String exerciseId) {
    List<ExerciseSet> exerciseSets = [];
    exercises[exerciseId].sets.forEach((exerciseSetId) {
      exerciseSets.add(getExerciseSet(exerciseSetId));
    });
    return exerciseSets;
  } */

  ExerciseSet getExerciseSet(String id) {
    return exerciseSets[id];
  }

  // --------------- User ---------------

  void createUserDocument({
    @required String id,
    @required String name,
    @required String email,
  }) =>
      usersRef.doc(id).set(
          {'id': id, 'name': name, 'email': email}, SetOptions(merge: true));

  Future<bool> doesUserDocExist(String id) async {
    DocumentSnapshot userDoc = await usersRef.doc(id).get();
    return Future.value(userDoc.exists);
  }
}
