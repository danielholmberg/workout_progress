import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Workout {
  final String id;
  String name;
  final List<String> exercises;
  Timestamp startTimeAndDate;
  int duration;
  double totalVolume;
  final Timestamp created;

  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String exercisesKey = 'exercises';
  static const String startTimeAndDateKey = 'startTimeAndDate';
  static const String durationKey = 'duration';
  static const String totalVolumeKey = 'totalVolume';
  static const String createdKey = 'created';

  Workout({
    @required this.id,
    @required this.name,
    @required this.exercises,
    @required this.startTimeAndDate,
    this.duration,
    this.totalVolume,
    @required this.created,
  });

  factory Workout.fromSnapshot(DocumentSnapshot doc) {
    var startTimeAndDate = doc.data()[startTimeAndDateKey];
    var created = doc.data()[createdKey];

    if (startTimeAndDate.runtimeType == int) {
      startTimeAndDate = Timestamp.fromMillisecondsSinceEpoch(startTimeAndDate);
    }
    if (created.runtimeType == int) {
      created = Timestamp.fromMillisecondsSinceEpoch(created);
    }

    return Workout(
      id: doc.data()[idKey] ?? doc.id,
      name: doc.data()[nameKey] ?? '',
      exercises: List.from(doc.data()[exercisesKey] ?? []),
      startTimeAndDate: startTimeAndDate ?? Timestamp(0, 0),
      duration: doc.data()[durationKey] ?? 0,
      totalVolume: doc.data()[totalVolumeKey] ?? 0.0,
      created: created ?? Timestamp(0, 0),
    );
  }

  factory Workout.emptyWorkout(String id) {
    return Workout(
      id: id,
      name: '',
      exercises: List.from([]),
      startTimeAndDate: Timestamp(0, 0),
      duration: 0,
      totalVolume: 0.0,
      created: Timestamp(0, 0),
    );
  }

  int get currentTime => this.duration;
  void setCurrentTime(int duration) => this.duration = duration;

  void setName(String newName) => this.name = newName;

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      nameKey: name,
      exercisesKey: exercises,
      startTimeAndDateKey: startTimeAndDate,
      durationKey: duration,
      totalVolumeKey: totalVolume,
      createdKey: created,
    };
  }

  @override
  String toString() {
    return toDocument().toString();
  }
}
