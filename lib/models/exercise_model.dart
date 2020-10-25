import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum EquipmentType {
  NONE,
  MACHINE,
  FREE,
  BODY,
}

class Exercise extends Equatable {
  final String id;
  final String name;
  final String bodyPartId;
  final int reps;
  final int sets;
  final double weight;
  final EquipmentType equipmentType;
  final List<String> instructions;
  final Map<String, List<String>> tips;
  final String warning;

  Exercise({
    @required this.id,
    @required this.name,
    @required this.bodyPartId,
    @required this.reps,
    @required this.sets,
    @required this.weight,
    @required this.equipmentType,
    @required this.instructions,
    this.tips,
    this.warning,
  });

  factory Exercise.fromSnapshot(DocumentSnapshot doc) {
    return Exercise(
      id: doc.data()['id'],
      name: doc.data()['name'] ?? '',
      bodyPartId: doc.data()['bodyPartId'] ?? '',
      reps: doc.data()['reps'] ?? 0,
      sets: doc.data()['sets'] ?? 0,
      weight: doc.data()['weight'] ?? 0.0,
      equipmentType: doc.data()['equipmentType'] ?? EquipmentType.NONE,
      instructions: doc.data()['instructions'] ?? [],
      tips: Map.from(doc.data()['tips'] ?? {}),
      warning: doc.data()['warning'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        bodyPartId,
        reps,
        sets,
        weight,
        equipmentType,
        instructions,
        tips,
      ];

  @override
  bool get stringify => true;
}
