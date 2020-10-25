import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum MuscleType {
  NAM, // Not A Muscle

  // Legs
  QUADRICEPS,
  GLUTEUS,
  HAMSTRINGS,
  GASTROCNEMIUS,
  SOLUES,

  // Lumbar Spine
  ERECTOR_SPINAE,
  QUADRATUS_LUMBORUM,

  // Core
  RECTUS_ABDOMINIS,
  OBLIQUUS_EXTERNUS,
  OBLIQUUS_INTERNUS,

  // Triceps
  TRICEPS_BRACHII,
  ANCONEUS,

  // Biceps
  BICEPS_BRACHII,
  BRACHIALIS,
  BRACHIORADIALIS,
  FLEXOR_DIGITORUM,

  // Chest
  PECTORALIS,

  // Shoulders,
  DELTOIDEUS,
  DELTOIDEUS_ANTERIOR,
  DELTOIDEUS_MEDIALIS,
  DELTOIDEUS_POSTERIOR,

  // Back,
  LATISSIMUS_DORSI,
  TRAPEZIUS,
  TERES_MAJOR,
}

class Muscle extends Equatable {
  final String id;
  final String name;
  final MuscleType type;
  final List<String> exercises;

  Muscle({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.exercises,
  });

  factory Muscle.fromSnapshot(DocumentSnapshot doc) {
    return Muscle(
      id: doc.data()['id'],
      name: doc.data()['name'] ?? '',
      type: doc.data()['type'] ?? MuscleType.NAM,
      exercises: List.from(doc.data()['exercises'] ?? []),
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        type,
        exercises,
      ];

  @override
  bool get stringify => true;
}
