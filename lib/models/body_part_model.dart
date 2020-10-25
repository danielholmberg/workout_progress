import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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

class BodyPart extends Equatable {
  final String id;
  final String name;
  final BodyPartType type;
  final List<String> muscles;

  BodyPart({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.muscles,
  });

  factory BodyPart.fromSnapshot(DocumentSnapshot doc) {
    return BodyPart(
      id: doc.data()['id'],
      name: doc.data()['name'] ?? '',
      type: doc.data()['type'] ?? BodyPartType.NABP,
      muscles: List.from(doc.data()['muscles'] ?? []),
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        type,
        muscles,
      ];

  @override
  bool get stringify => true;
}
