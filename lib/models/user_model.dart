import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MyUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final double initialWeight;
  final double currentWeight;
  final String initialWorkoutId;
  final List<String> scheduledWorkouts;
  final int numberOfWorkouts;

  MyUser({
    @required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.initialWeight,
    this.currentWeight,
    this.initialWorkoutId,
    this.scheduledWorkouts,
    this.numberOfWorkouts,
  });

  factory MyUser.fromSnapshot(DocumentSnapshot doc) {
    return MyUser(
      id: doc['id'],
      name: doc.data()['name'] ?? '',
      email: doc.data()['email'] ?? '',
      photoUrl: doc.data()['photoUrl'] ?? '',
      initialWeight: doc.data()['initialWeight'] ?? 0.0,
      currentWeight: doc.data()['currentWeight'] ?? 0.0,
      initialWorkoutId: doc.data()['initialWorkoutId'],
      scheduledWorkouts: List.from(doc.data()['sceduledWorkouts'] ?? []),
      numberOfWorkouts: doc.data()['numberOfWorkouts'] ?? 0,
    );
  }

  String get firstName => name.trim().split(' ').first;
  String get lastName => name.trim().split(' ').last;

  @override
  List<Object> get props => [
        id,
        name,
        email,
        photoUrl,
        initialWeight,
        currentWeight,
        initialWorkoutId,
        scheduledWorkouts,
        numberOfWorkouts,
      ];

  @override
  bool get stringify => true;
}
