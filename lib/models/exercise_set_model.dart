import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ExerciseSet {
  final String id;
  final String exerciseId;
  final int index;
  final double previous;
  double volume;
  int reps;
  bool completed;

  static const idKey = 'id';
  static const exerciseIdKey = 'exerciseId';
  static const indexKey = 'index';
  static const previousKey = 'previous';
  static const volumeKey = 'volume';
  static const repsKey = 'reps';
  static const completedKey = 'completed';

  ExerciseSet({
    @required this.id,
    @required this.exerciseId,
    @required this.index,
    this.previous,
    this.volume,
    this.reps,
    this.completed = false,
  });

  factory ExerciseSet.fromSnapshot(DocumentSnapshot doc) {

    return ExerciseSet(
      id: doc.data()[idKey] ?? doc.id,
      exerciseId: doc.data()[exerciseIdKey] ?? '',
      index: doc.data()[indexKey] ?? 0,
      previous: doc.data()[previousKey] ?? 0.0,
      volume: doc.data()[volumeKey] ?? 0.0,
      reps: doc.data()[repsKey] ?? 0,
      completed: doc.data()[completedKey] ?? false,
    );
  }

  factory ExerciseSet.emptySet(String id, String exerciseId, int index) {
    return ExerciseSet(
      id: id,
      exerciseId: exerciseId,
      index: index,
      previous: 0.0,
      volume: 0.0,
      reps: 0,
      completed: false,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      exerciseIdKey: exerciseId,
      indexKey: index,
      previousKey: previous,
      volumeKey: volume,
      repsKey: reps,
      completedKey: completed,
    };
  }

  @override
  String toString() {
    return toDocument().toString();
  }

  bool get isCompleted => this.completed;

  void setCompleted(bool completed) => this.completed = completed;

  void toggleCompleted() => this.completed = !completed;
}
