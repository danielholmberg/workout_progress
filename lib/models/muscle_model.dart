import 'package:cloud_firestore/cloud_firestore.dart';
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

class Muscle {
  final String id;
  final String name;
  final MuscleType type;
  final List<String> exercises;

  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String typeKey = 'type';
  static const String exercisesKey = 'exercises';

  Muscle({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.exercises,
  });

  factory Muscle.fromSnapshot(DocumentSnapshot doc) {
    return Muscle(
      id: doc.data()[idKey] ?? doc.id,
      name: doc.data()[nameKey] ?? '',
      type: doc.data()[typeKey] ?? MuscleType.NAM,
      exercises: List.from(doc.data()[exercisesKey] ?? []),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      idKey: id,
      nameKey: name,
      typeKey: type,
      exercisesKey: exercises,
    };
  }
}
