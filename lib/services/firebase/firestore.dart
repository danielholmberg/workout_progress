import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/services/firebase/auth.dart';

import '../../locator.dart';
import '../../models/exercise_model.dart';
import '../../models/exercise_set_model.dart';
import '../../models/workout_model.dart';

class FirebaseFirestoreService with ReactiveServiceMixin {
  final FirebaseAuthService authService = locator<FirebaseAuthService>();

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _baseExercisesRef =
      FirebaseFirestore.instance.collection('available_exercises');

  StreamSubscription _baseExercisesStreamSub;
  StreamSubscription _workoutsStreamSub;
  StreamSubscription _exercisesStreamSub;
  StreamSubscription _exerciseSetsStreamSub;

  final RxValue<Map<String, BaseExercise>> _baseExercises =
      RxValue<Map<String, BaseExercise>>(initial: {});
  final RxValue<Map<String, Workout>> _workouts =
      RxValue<Map<String, Workout>>(initial: {});
  final RxValue<Map<String, Exercise>> _exercises =
      RxValue<Map<String, Exercise>>(initial: {});
  final RxValue<Map<String, ExerciseSet>> _exerciseSets =
      RxValue<Map<String, ExerciseSet>>(initial: {});
  final RxValue<Map<String, List<ExerciseSet>>> _completedSets =
      RxValue<Map<String, List<ExerciseSet>>>(initial: {});

  FirebaseFirestoreService() {
    listenToReactiveValues([
      _baseExercises,
      _workouts,
      _exercises,
      _exerciseSets,
      _completedSets,
    ]);
  }

  Map<String, BaseExercise> get baseExercises => _baseExercises.value;
  Map<String, Workout> get workouts => _workouts.value;
  Map<String, Exercise> get exercises => _exercises.value;
  Map<String, ExerciseSet> get exerciseSets => _exerciseSets.value;
  Map<String, List<ExerciseSet>> get completedSets => _completedSets.value;

  StreamSubscription get baseExerciseStreamSub => _baseExercisesStreamSub;
  StreamSubscription get workoutsStreamSub => _workoutsStreamSub;
  StreamSubscription get exercisesStreamSub => _exercisesStreamSub;
  StreamSubscription get exerciseSetsStreamSub => _exerciseSetsStreamSub;

  // User specific
  CollectionReference get workoutsRef =>
      _usersRef.doc(authService.currentUser.id).collection('workouts');
  CollectionReference get exercisesRef =>
      _usersRef.doc(authService.currentUser.id).collection('exercises');
  CollectionReference get exerciseSetsRef =>
      _usersRef.doc(authService.currentUser.id).collection('exerciseSets');
  CollectionReference get musclesRef =>
      _usersRef.doc(authService.currentUser.id).collection('muscles');
  CollectionReference get bodyPartsRef =>
      _usersRef.doc(authService.currentUser.id).collection('body_parts');

  String get newWorkoutId => workoutsRef.doc().id;
  String get newExerciseId => exercisesRef.doc().id;
  String get newExerciseSetId => exerciseSetsRef.doc().id;

  setUpListeners() {
    print('Setting up Firestore listeners...');
    _baseExercisesStreamSub = _baseExercisesRef
        .orderBy(
          BaseExercise.nameKey,
        )
        .snapshots()
        .listen(
      (event) {
        event.docChanges.forEach(
          (docChange) {
            BaseExercise baseExercise =
                BaseExercise.fromSnapshot(docChange.doc);
            if (docChange.type == DocumentChangeType.removed) {
              print(
                  'Base Exercise (${baseExercise.id})[${baseExercise.name}] removed!');
              if (baseExercises.containsKey(baseExercise.id)) {
                baseExercises.remove(baseExercise.id);
              }
            } else {
              if (docChange.type == DocumentChangeType.modified) {
                print(
                  'Base Exercise (${baseExercise.id})[${baseExercise.name}] modified!',
                );
              } else if (docChange.type == DocumentChangeType.added) {
                print(
                  'Base Exercise (${baseExercise.id})[${baseExercise.name}] added!',
                );
              }

              baseExercises.update(baseExercise.id, (be) => baseExercise,
                  ifAbsent: () => baseExercise);
            }
          },
        );
        notifyListeners();
      },
    );

    // Workouts
    _workoutsStreamSub = workoutsRef
        .orderBy(
          Workout.createdKey,
        )
        .snapshots()
        .listen(
      (event) {
        event.docChanges.forEach(
          (docChange) {
            Workout workout = Workout.fromSnapshot(docChange.doc);
            if (docChange.type == DocumentChangeType.removed) {
              print('Base Exercise (${workout.id})[${workout.name}] removed!');
              if (workouts.containsKey(workout.id)) {
                workouts.remove(workout.id);
              }
            } else {
              if (docChange.type == DocumentChangeType.modified) {
                print('Workout (${workout.id})[${workout.name}] modified!');
              } else if (docChange.type == DocumentChangeType.added) {
                print('Workout (${workout.id})[${workout.name}] added!');
              }

              workouts.update(workout.id, (w) => workout,
                  ifAbsent: () => workout);
            }
          },
        );
        notifyListeners();
      },
    );

    // Exercises
    _exercisesStreamSub = exercisesRef
        .orderBy(
          Exercise.indexKey,
        )
        .snapshots()
        .listen(
      (event) {
        event.docChanges.forEach(
          (docChange) {
            Exercise exercise = Exercise.fromSnapshot(docChange.doc);
            if (docChange.type == DocumentChangeType.removed) {
              print('Exercise (${exercise.id}) removed!');
              if (exercises.containsKey(exercise.id)) {
                exercises.remove(exercise.id);
              }
            } else {
              if (docChange.type == DocumentChangeType.modified) {
                print('Exercise (${exercise.id}) modified!');
              } else if (docChange.type == DocumentChangeType.added) {
                print('Exercise (${exercise.id}) added!');
              }

              exercises.update(exercise.id, (e) => exercise,
                  ifAbsent: () => exercise);
            }
          },
        );
        notifyListeners();
      },
    );

    // Exercise Sets
    _exerciseSetsStreamSub = exerciseSetsRef
        .orderBy(
          ExerciseSet.indexKey,
        )
        .snapshots()
        .listen(
      (event) {
        event.docChanges.forEach(
          (docChange) {
            ExerciseSet exerciseSet = ExerciseSet.fromSnapshot(docChange.doc);
            if (docChange.type == DocumentChangeType.removed) {
              print('Exercise Set (${exerciseSet.id}) removed!');
              if (exerciseSets.containsKey(exerciseSet.id)) {
                exerciseSets.remove(exerciseSet.id);
              }

              if (exerciseSet.isCompleted) {
                removeCompletedExerciseSet(exerciseSet);
              }
            } else {
              if (docChange.type == DocumentChangeType.modified) {
                print(
                  'Exercise Set (${exerciseSet.id})[${exerciseSet.exerciseId}] modified! [completed: ${exerciseSet.isCompleted}]',
                );
                if (!exerciseSet.isCompleted) {
                  removeCompletedExerciseSet(exerciseSet);
                }
              } else if (docChange.type == DocumentChangeType.added) {
                print(
                  'Exercise Set (${exerciseSet.id})[${exerciseSet.exerciseId}] added! [completed: ${exerciseSet.isCompleted}]',
                );
              }

              exerciseSets.update(exerciseSet.id, (es) => exerciseSet,
                  ifAbsent: () => exerciseSet);

              if (exerciseSet.isCompleted) {
                completedSets.putIfAbsent(exerciseSet.baseExerciseId, () => []);

                print(
                  'Adding (${exerciseSet.id}) to completed-list for BaseExercise(${exerciseSet.baseExerciseId})!',
                );

                completedSets.update(
                  exerciseSet.baseExerciseId,
                  (list) {
                    list.add(exerciseSet);
                    return list;
                  },
                  ifAbsent: () => [exerciseSet],
                );
              }
            }
          },
        );
        notifyListeners();
      },
    );
    print('Success!');
  }

  cancelListeners() {
    print('Cancelling Firestore listeners...');
    _baseExercisesStreamSub.cancel();
    _workoutsStreamSub.cancel();
    _exercisesStreamSub.cancel();
    _exerciseSetsStreamSub.cancel();
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
    }).then(
      (value) => print('Created Workout($id)'),
      onError: (error) => print('Error creating Workout($id): $error'),
    );
  }

  Future saveWorkout(Workout workout) {
    return workoutsRef.doc(workout.id).set(workout.toDocument()).then(
          (value) => print('Saved Workout(${workout.id})'),
          onError: (error) =>
              print('Error saving Workout(${workout.id}): $error'),
        );
  }

  Future deleteWorkout(Workout workout) async {
    for (String exerciseId in workout.exercises) {
      await deleteExercise(exerciseId);
    }
    return workoutsRef.doc(workout.id).delete().then(
          (value) => print('Deleted Workout(${workout.id})'),
          onError: (error) =>
              print('Error deleting Workout(${workout.id}): $error'),
        );
  }

  List<Workout> getAllWorkouts() {
    return workouts.values.toList();
  }

  Workout getWorkout(String id) {
    return workouts[id];
  }

  // --------------- Exercise ---------------

  Future createExercise(Exercise newExercise) {
    return exercisesRef.doc(newExercise.id).set(newExercise.toDocument()).then(
          (value) => print('Created Exercise(${newExercise.id})'),
          onError: (error) =>
              print('Error creating Exercise(${newExercise.id}): $error'),
        );
  }

  Future saveExercise(Exercise exercise) async {
    if (exercise.setsToCreate.isNotEmpty) {
      await saveExerciseSets(exercise.setsToCreate.values.toList());
      exercise.setsToCreate.clear();
    }

    for(String exerciseSetId in exercise.sets) {
      ExerciseSet exerciseSet = exerciseSets[exerciseSetId];
      await saveExerciseSet(exerciseSet);
    }

    return exercisesRef.doc(exercise.id).set(exercise.toDocument()).then(
          (value) => print('Saved Exercise(${exercise.id})'),
          onError: (error) =>
              print('Error saving Exercise(${exercise.id}): $error'),
        );
  }

  Future saveExercises(List<Exercise> exerciseList) async {
    for (Exercise exercise in exerciseList) {
      await saveExercise(exercise);
    }
  }

  Future deleteExercise(String exerciseId) async {
    Exercise exerciseToDelete = getExercise(exerciseId);
    if (exerciseToDelete != null) {
      for (String exerciseSetId in exerciseToDelete.sets) {
        await deleteExerciseSet(exerciseSetId);
      }
    } else {
      print('Error deleting Exercise($exerciseId): Exercise doesn\'t exist');
    }
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

  Future saveExerciseSet(ExerciseSet exerciseSet) {
    return exerciseSetsRef
        .doc(exerciseSet.id)
        .set(exerciseSet.toDocument())
        .then(
          (value) => print('Saved ExerciseSet(${exerciseSet.id})'),
          onError: (error) =>
              print('Error saving ExerciseSet(${exerciseSet.id}): $error'),
        );
  }

  Future saveExerciseSets(List<ExerciseSet> exerciseSetList) async {
    for (ExerciseSet exerciseSet in exerciseSetList) {
      await saveExerciseSet(exerciseSet);
    }
  }

  Future deleteExerciseSet(String exerciseSetId) async {
    return exerciseSetsRef.doc(exerciseSetId).delete().then(
          (value) => print('Deleted ExerciseSet($exerciseSetId)'),
          onError: (error) =>
              print('Error deleting ExerciseSet($exerciseSetId): $error'),
        );
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

  List<ExerciseSet> getCompletedExerciseSets(String baseExerciseId) {
    return exerciseSets.values.where((exerciseSet) => exerciseSet.isCompleted);
  }

  void removeCompletedExerciseSet(ExerciseSet exerciseSet) {
    List<ExerciseSet> exerciseSetList =
        completedSets[exerciseSet.baseExerciseId];
    if (exerciseSetList != null) {
      exerciseSetList.removeWhere((e) => e.id.compareTo(exerciseSet.id) == 0);
    }
  }

  // --------------- User ---------------

  Future createUserDocument({
    @required String id,
    @required String name,
    @required String email,
  }) {
    final userData = {'id': id, 'name': name, 'email': email};
    return _usersRef
        .doc(id)
        .set(
          userData,
          SetOptions(merge: true),
        )
        .then(
          (value) => print('Created User($userData)'),
          onError: (error) => print('Error saving User($userData): $error'),
        );
  }

  Future<bool> doesUserDocExist(String id) async {
    DocumentSnapshot userDoc = await _usersRef.doc(id).get();
    return Future.value(userDoc.exists);
  }
}
