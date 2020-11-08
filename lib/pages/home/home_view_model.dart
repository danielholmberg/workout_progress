import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/user_model.dart';
import 'package:workout_progress/services/firebase/auth.dart';
import 'package:workout_progress/services/util_service.dart';

import '../../locator.dart';
import '../../router.dart';
import '../../services/firebase/firestore.dart';

class HomeViewModel extends ReactiveViewModel {
  final FirebaseFirestoreService _dbService =
      locator<FirebaseFirestoreService>();
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final UtilService _utilService = locator<UtilService>();

  void initialise() => _dbService.setUpListeners();

  void navigateToSettings() =>
      _navigationService.navigateTo(Router.settingsRoute);
  void navigateToNewWorkout() =>
      _navigationService.navigateTo(Router.newWorkoutRoute);

  String get today => _utilService.today;
  String get greeting => _utilService.greeting;
  Widget get currentUserAvatar => _authService.currentUserAvatar;
  MyUser get currentUser => _authService.currentUser;

  @override
  void dispose() {
    _dbService.cancelListeners();
    super.dispose();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_utilService];
}
