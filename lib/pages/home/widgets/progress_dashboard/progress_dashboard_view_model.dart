import 'package:fl_chart/fl_chart.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/models/exercise_set_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';

import '../../../../locator.dart';

class ProgressDashboardViewModel extends ReactiveViewModel {
  final FirebaseFirestoreService _dbService =
      locator<FirebaseFirestoreService>();

  double _minValueY;
  double _maxValueY;
  double _minValueX;
  double _maxValueX;

  int get baseExercisesCount => _dbService.baseExercises.length;
  double get minValueY => _minValueY;
  double get maxValueY => _maxValueY + (_maxValueY / 4);
  double get minValueX => _minValueX;
  double get maxValueX => _maxValueX;

  List<FlSpot> generateSpots(String baseExerciseId) {
    List<ExerciseSet> completedExerciseSets =
        _dbService.completedSets[baseExerciseId];
    if (completedExerciseSets == null || completedExerciseSets.isEmpty)
      return [];

    Map<double, FlSpot> exerciseSetSpots = {};
    resetMinMaxValues();

    completedExerciseSets.forEach((baseExerciseSet) {
      calculateMinMaxValues(baseExerciseSet);
      exerciseSetSpots.update(
        baseExerciseSet.spot.x,
        (currentSpot) => currentSpot.y < baseExerciseSet.spot.y
            ? baseExerciseSet.spot
            : currentSpot,
        ifAbsent: () => baseExerciseSet.spot,
      );
    });

    exerciseSetSpots.keys.toList().sort((x0, x1) => x0.compareTo(x1));

    return exerciseSetSpots.values.toList();
  }

  void resetMinMaxValues() {
    _minValueX = null;
    _maxValueX = null;
    _minValueY = null;
    _maxValueY = null;
  }

  void calculateMinMaxValues(ExerciseSet baseExerciseSet) {
    BaseExercise baseExercise = _dbService.getBaseExercise(baseExerciseSet.baseExerciseId);

    _minValueY = baseExercise.min;
    _maxValueY = baseExercise.max;

    if(_minValueX == null) _minValueX = baseExerciseSet.spot.x;
    if(_maxValueX == null) _maxValueX = baseExerciseSet.spot.x;

    _minValueX = _minValueX < baseExerciseSet.spot.x
        ? _minValueX
        : baseExerciseSet.spot.x;
    _maxValueX = _maxValueX < baseExerciseSet.spot.x
        ? baseExerciseSet.spot.x
        : _maxValueX;

    print('minValueX: ' + _minValueX.toString());
    print('maxValueX: ' + _maxValueX.toString());
    print('minValueY: ' + _minValueY.toString());
    print('maxValueY: ' + _maxValueY.toString());
  }

  BaseExercise getBaseExercise(int index) =>
      _dbService.baseExercises.values.toList()[index];

  String generateLeftTiles(double value) {
    switch (value.toInt()) {
      case 10:
        return '10';
      case 30:
        return '30';
      case 50:
        return '50';
      default:
        return '';
    }
  }

  String generateBottomTiles(double value) {
    print('value: '+value.toString());
    switch (value.toInt()) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tus';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_dbService];
}
