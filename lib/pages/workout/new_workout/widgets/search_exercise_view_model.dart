import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';

import '../../../../locator.dart';

class SearchExerciseViewModel extends ReactiveViewModel {
  final FirebaseFirestoreService _dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<BaseExercise> _searchResult;
  List<BaseExercise> _selectedBaseExercises;
  TextEditingController _searchController;
  Function(List<BaseExercise>) _addBaseExercisesToWorkout;

  void initialise(
    TextEditingController searchController,
    Function(List<BaseExercise>) addBaseExercisesToWorkout,
  ) {
    _searchController = searchController;
    _searchResult = List.from(baseExercises);
    _selectedBaseExercises = [];
    _addBaseExercisesToWorkout = addBaseExercisesToWorkout;
  }

  List<BaseExercise> get baseExercises => _dbService.getBaseExercises();
  TextEditingController get searchController => _searchController;
  int get resultsCount => _searchResult.length;
  bool get hasSelectedBaseExercises => _selectedBaseExercises.isNotEmpty;

  void onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      _searchResult.addAll(baseExercises);
    } else {
      _searchResult.clear();
      _searchResult.addAll(baseExercises);

      baseExercises.forEach((BaseExercise baseExercise) {
        if (baseExercise.name.toLowerCase().contains(text.toLowerCase())) {
          if (!_searchResult.contains(baseExercise)) {
            _searchResult.add(baseExercise);
          }
        } else {
          if (_searchResult.contains(baseExercise)) {
            _searchResult.remove(baseExercise);
          }
        }
      });
    }

    notifyListeners();
  }

  void resetSearch() {
    _searchController.clear();
    onSearchTextChanged('');
  }

  void onBaseExerciseSelected(bool selected, BaseExercise baseExercise) {
    baseExercise.setSelected(selected);
    baseExercises.firstWhere((BaseExercise e) {
      return e.id.compareTo(baseExercise.id) == 0;
    }).setSelected(selected);
    if (selected) {
      if (!_selectedBaseExercises.contains(baseExercise)) {
        _selectedBaseExercises.add(baseExercise);
      }
    } else {
      if (_selectedBaseExercises.contains(baseExercise)) {
        _selectedBaseExercises.remove(baseExercise);
      }
    }
    notifyListeners();
  }

  Future<bool> onWillPop({bool isActionButton}) async {
    await _addBaseExercisesToWorkout(_selectedBaseExercises);
    if (isActionButton) {
      _navigationService.back();
    }
    return Future.value(true);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_dbService];

  BaseExercise getBaseExerciseItem(int index) => _searchResult[index];
}
