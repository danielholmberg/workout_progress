import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'exercise_set_model.dart';

class Exercise {
  final String id;
  int index;
  final String workoutId;
  final String baseExerciseId;
  final List<String> sets;
  bool isSelected;
  final Map<String, ExerciseSet> setsToCreate;

  static const idKey = 'id';
  static const workoutIdKey = 'workoutId';
  static const indexKey = 'index';
  static const baseExerciseIdKey = 'baseExerciseId';
  static const setsKey = 'sets';

  Exercise({
    @required this.id,
    this.index,
    @required this.workoutId,
    @required this.baseExerciseId,
    this.sets,
    this.isSelected = false,
    this.setsToCreate,
  });

  factory Exercise.fromSnapshot(DocumentSnapshot doc) {
    return Exercise(
      id: doc.data()[idKey] ?? doc.id,
      index: doc.data()[indexKey] ?? 0,
      workoutId: doc.data()[workoutIdKey] ?? '',
      baseExerciseId: doc.data()[baseExerciseIdKey] ?? '',
      sets: List.from(doc.data()[setsKey] ?? []),
      setsToCreate: Map.from({}),
    );
  }

  factory Exercise.emptyExercise(
    String id,
    int index,
    String workoutId,
    String baseExerciseId,
  ) {
    return Exercise(
      id: id,
      index: index,
      workoutId: workoutId,
      baseExerciseId: baseExerciseId,
      sets: List.from([]),
      setsToCreate: Map.from({}),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      indexKey: index,
      workoutIdKey: workoutId,
      baseExerciseIdKey: baseExerciseId,
      setsKey: sets,
    };
  }

  @override
  String toString() {
    return toDocument().toString();
  }

  void setIndex(int index) => this.index = index;

  bool get selected => this.isSelected;

  void setSelected(bool selected) => this.isSelected = selected;

  void toggleSelected() => this.isSelected = !this.isSelected;
}
