import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../models/body_part_model.dart';
import '../../models/exercise_model.dart';
import '../../models/workout_model.dart';

class FirebaseFirestoreService {

  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final CollectionReference musclesRef = FirebaseFirestore.instance.collection('muscles');
  final CollectionReference bodyPartsRef = FirebaseFirestore.instance.collection('body_parts');
  final CollectionReference exercisesRef = FirebaseFirestore.instance.collection('exercises');
  final CollectionReference workoutsRef = FirebaseFirestore.instance.collection('workouts');

  void createUserDocument({@required String id, @required String name, @required String email}) => usersRef.doc(id).set({
    'id': id, 'name': name, 'email': email
  }, SetOptions(merge: true));

  Stream<List<Workout>> get workouts => workoutsRef.orderBy('created', descending: true).snapshots()
  .map((list) => list.docs.map((doc) => Workout.fromSnapshot(doc)).toList());

  Future<BodyPart> getBodyPart(DocumentReference bodyPartRef) {
    return bodyPartRef.get().then((doc) => BodyPart.fromSnapshot(doc));
  }

  Future<Exercise> getExercise(DocumentReference exerciseRef) {
    return exerciseRef.get().then((doc) => Exercise.fromSnapshot(doc));
  }

  Future<bool> doesUserExist(String id) async {
    DocumentSnapshot userDoc = await usersRef.doc(id).get();
    return userDoc.exists;
  }

  Future createTestWorkout() async {
    print('Creating Test workout...');
    DocumentReference newWorkout = workoutsRef.doc();
    return workoutsRef.doc(newWorkout.id).set({
      'id': newWorkout.id,
      'name': 'Test Workout',
      'exercises': [],
      'startTimeAndDate': FieldValue.serverTimestamp(),
      'duration': 45,
      'actualDuration': 36,
      'totalVolume': 125.0,
      'created': FieldValue.serverTimestamp(),
    });
  }

}