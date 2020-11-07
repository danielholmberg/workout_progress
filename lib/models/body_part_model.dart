import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum BodyPartType {
  NABP, // Not A Body Part
  LEG,
  CHEST,
  BACK,
  SHOULDER,
  LUMBAR_SPINE,
  TRICEP,
  BICEP,
  CORE,
}

class BodyPart {
  final String id;
  final String name;
  final BodyPartType type;
  final List<String> muscles;

  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String typeKey = 'type';
  static const String musclesKey = 'muscles';

  BodyPart({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.muscles,
  });

  factory BodyPart.fromSnapshot(DocumentSnapshot doc) {
    return BodyPart(
      id: doc.data()[idKey] ?? doc.id,
      name: doc.data()[nameKey] ?? '',
      type: doc.data()[typeKey] ?? BodyPartType.NABP,
      muscles: List.from(doc.data()[musclesKey] ?? []),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      nameKey: name,
      typeKey: type,
      musclesKey: muscles,
    };
  }
}
