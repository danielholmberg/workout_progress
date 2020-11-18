import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ExerciseSet {
  final String id;
  final String baseExerciseId;
  final String exerciseId;
  final String workoutId;
  final int index;
  final double previous;
  double volume;
  int reps;
  bool completed;
  Timestamp dateCompleted;

  static const idKey = 'id';
  static const exerciseIdKey = 'exerciseId';
  static const workoutIdKey = 'workoutId';
  static const baseExerciseIdKey = 'baseExerciseId';
  static const indexKey = 'index';
  static const previousKey = 'previous';
  static const volumeKey = 'volume';
  static const repsKey = 'reps';
  static const completedKey = 'completed';
  static const dateCompletedKey = 'dateCompleted';

  ExerciseSet({
    @required this.id,
    @required this.exerciseId,
    @required this.workoutId,
    @required this.baseExerciseId,
    @required this.index,
    this.previous,
    this.volume,
    this.reps,
    this.completed = false,
    this.dateCompleted,
  });

  factory ExerciseSet.fromSnapshot(DocumentSnapshot doc) {
    var dateCompleted = doc.data()[dateCompletedKey];
    if (dateCompleted.runtimeType == int) {
      dateCompleted = Timestamp.fromMillisecondsSinceEpoch(dateCompleted);
    }

    return ExerciseSet(
      id: doc.data()[idKey] ?? doc.id,
      exerciseId: doc.data()[exerciseIdKey] ?? '',
      workoutId: doc.data()[workoutIdKey] ?? '',
      baseExerciseId: doc.data()[baseExerciseIdKey] ?? '',
      index: doc.data()[indexKey] ?? 0,
      previous: doc.data()[previousKey] ?? 0.0,
      volume: doc.data()[volumeKey] ?? 0.0,
      reps: doc.data()[repsKey] ?? 0,
      completed: doc.data()[completedKey] ?? false,
      dateCompleted: dateCompleted ?? Timestamp(0, 0),
    );
  }

  factory ExerciseSet.emptySet(
      String id, String exerciseId, String baseExerciseId, String workoutId, int index) {
    return ExerciseSet(
      id: id,
      exerciseId: exerciseId,
      workoutId: workoutId,
      baseExerciseId: baseExerciseId,
      index: index,
      previous: 0.0,
      volume: 0.0,
      reps: 0,
      completed: false,
      dateCompleted: Timestamp(0, 0),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      exerciseIdKey: exerciseId,
      workoutIdKey: workoutId,
      baseExerciseIdKey: baseExerciseId,
      indexKey: index,
      previousKey: previous,
      volumeKey: volume,
      repsKey: reps,
      completedKey: completed,
      dateCompletedKey: dateCompleted,
    };
  }

  @override
  String toString() {
    return toDocument().toString();
  }

  bool get isCompleted => this.completed;

  void setCompleted(bool completed) {
    this.completed = completed;
    this.dateCompleted =
        completed ? Timestamp.now() : Timestamp(0, 0);
  }

  void toggleCompleted() {
    this.completed = !completed;
    this.dateCompleted =
        completed ? Timestamp.now() : Timestamp(0, 0);
  }

  FlSpot get spot => FlSpot(
        (dateCompleted.toDate().year + dateCompleted.toDate().month + dateCompleted.toDate().day).toDouble(),
        volume,
      );
}
