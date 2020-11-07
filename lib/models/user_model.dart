import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MyUser {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final double initialWeight;
  final double currentWeight;
  final String initialWorkoutId;
  final List<String> scheduledWorkouts;
  final List<String> completedWorkouts;

  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String emailKey = 'email';
  static const String photoUrlKey = 'photoUrl';
  static const String initialWeightKey = 'initialWeight';
  static const String currentWeightKey = 'currentWeight';
  static const String initialWorkoutIdKey = 'initialWorkoutId';
  static const String scheduledWorkoutsKey = 'scheduledWorkouts';
  static const String completedWorkoutsKey = 'completedWorkouts';

  MyUser({
    @required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.initialWeight,
    this.currentWeight,
    this.initialWorkoutId,
    this.scheduledWorkouts,
    this.completedWorkouts,
  });

  factory MyUser.fromSnapshot(DocumentSnapshot doc) {
    return MyUser(
      id: doc.data()[idKey] ?? doc.id,
      name: doc.data()[nameKey] ?? '',
      email: doc.data()[emailKey] ?? '',
      photoUrl: doc.data()[photoUrlKey] ?? '',
      initialWeight: doc.data()[initialWeightKey] ?? 0.0,
      currentWeight: doc.data()[currentWeightKey] ?? 0.0,
      initialWorkoutId: doc.data()[initialWorkoutIdKey] ?? '',
      scheduledWorkouts: List.from(doc.data()[scheduledWorkoutsKey] ?? []),
      completedWorkouts: List.from(doc.data()[completedWorkoutsKey] ?? []),
    );
  }

  String get firstName => name.trim().split(' ').first;
  String get lastName => name.trim().split(' ').last;

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      nameKey: name,
      initialWeightKey: initialWeight,
      currentWeightKey: currentWeight,
      initialWorkoutIdKey: initialWorkoutId,
      scheduledWorkoutsKey: scheduledWorkouts,
      completedWorkoutsKey: completedWorkouts,
    };
  }
}
