import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

enum EquipmentType {
  NONE,
  MACHINE,
  FREE,
  BODY,
}

class BaseExercise {
  final String id;
  final String name;
  final String bodyPartId;
  final EquipmentType equipmentType;
  final List<String> instructions;
  final bool custom;
  final Map<String, List<String>> tips;
  final String warning;
  final double min;
  final double max;
  bool isSelected;

  static const idKey = 'id';
  static const nameKey = 'name';
  static const bodyPartIdKey = 'bodyPartId';
  static const equipmentTypeKey = 'equipmentType';
  static const instructionsKey = 'instructions';
  static const customKey = 'custom';
  static const tipsKey = 'tips';
  static const warningKey = 'warning';
  static const minKey = 'min';
  static const maxKey = 'max';

  BaseExercise({
    @required this.id,
    @required this.name,
    @required this.bodyPartId,
    @required this.equipmentType,
    @required this.instructions,
    this.custom = false,
    this.tips,
    this.warning,
    @required this.min,
    @required this.max,
    this.isSelected = false,
  });

  factory BaseExercise.fromSnapshot(DocumentSnapshot doc) {
    EquipmentType parseEquipmentType(String equipment) {
      switch (equipment.toLowerCase()) {
        case 'free':
          return EquipmentType.FREE;
          break;
        case 'body':
          return EquipmentType.BODY;
          break;
        case 'machine':
          return EquipmentType.MACHINE;
          break;
        default:
          return EquipmentType.NONE;
      }
    }

    return BaseExercise(
      id: doc.data()[idKey] ?? doc.id,
      name: doc.data()[nameKey] ?? '',
      bodyPartId: doc.data()[bodyPartIdKey] ?? '',
      equipmentType: parseEquipmentType(doc.data()[equipmentTypeKey] ?? ''),
      instructions: List.from(doc.data()[instructionsKey] ?? []),
      custom: doc.data()[customKey] ?? false,
      tips: Map.from(doc.data()[tipsKey] ?? {}),
      warning: doc.data()[warningKey] ?? '',
      min: (doc.data()[minKey] ?? 0.0).toDouble(),
      max: (doc.data()[maxKey] ?? 0.0).toDouble(),
    );
  }

  factory BaseExercise.emptyExercise(String id) {
    return BaseExercise(
      id: id,
      name: '',
      bodyPartId: '',
      equipmentType: EquipmentType.NONE,
      instructions: const [],
      custom: false,
      tips: Map.from({}),
      warning: '',
      min: 0.0,
      max: 0.0,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      nameKey: name,
      bodyPartIdKey: bodyPartId,
      equipmentTypeKey: equipment(),
      instructionsKey: instructions,
      customKey: custom,
      tipsKey: tips,
      warningKey: warning,
      minKey: min,
      maxKey: max,
    };
  }

  @override
  String toString() {
    return toDocument().toString();
  }

  String equipment() {
    switch (equipmentType) {
      case EquipmentType.FREE:
        return 'Free';
        break;
      case EquipmentType.BODY:
        return 'Body';
        break;
      case EquipmentType.MACHINE:
        return 'Machine';
        break;
      default:
        return 'None';
    }
  }

  bool get selected => this.isSelected;

  void setSelected(bool selected) => this.isSelected = selected;

  void toggleSelected() => this.isSelected = !this.isSelected;

}
