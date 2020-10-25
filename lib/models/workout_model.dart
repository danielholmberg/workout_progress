import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Workout extends Equatable {
  final String id;
  final String name;
  final List<String> exercises;
  final Timestamp startTimeAndDate;
  final int duration;
  final int actualDuration;
  final double totalVolume;
  final Timestamp created;

  Workout({
    @required this.id,
    @required this.name,
    @required this.exercises,
    @required this.startTimeAndDate,
    @required this.duration,
    @required this.actualDuration,
    @required this.totalVolume,
    @required this.created,
  });

  factory Workout.fromSnapshot(DocumentSnapshot doc) {
    print(doc);
    var startTimeAndDate = doc.data()['startTimeAndDate'];
    var created = doc.data()['created'];

    if (startTimeAndDate.runtimeType == int) {
      startTimeAndDate = Timestamp.fromMillisecondsSinceEpoch(startTimeAndDate);
    }
    if (created.runtimeType == int) {
      created = Timestamp.fromMillisecondsSinceEpoch(created);
    }

    return Workout(
      id: doc.data()['id'],
      name: doc.data()['name'],
      exercises: List.from(doc.data()['exercises'] ?? []),
      startTimeAndDate: startTimeAndDate,
      duration: doc.data()['duration'] ?? 0,
      actualDuration: doc.data()['actualDuration'] ?? 0,
      totalVolume: doc.data()['totalVolume'] ?? 0.0,
      created: created,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        exercises,
        startTimeAndDate,
        duration,
        actualDuration,
        totalVolume,
        created,
      ];

  @override
  bool get stringify => true;
}
