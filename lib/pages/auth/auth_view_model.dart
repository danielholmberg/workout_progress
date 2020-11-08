import 'package:stacked/stacked.dart';
import 'package:workout_progress/models/user_model.dart';
import 'package:workout_progress/services/util_service.dart';

import '../../locator.dart';
import '../../services/firebase/auth.dart';

class AuthViewModel extends ReactiveViewModel {
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final UtilService _utilService = locator<UtilService>();

  void initialise() {
    _authService.setUpListeners();
    generateDataAndGreeting();
  }

  MyUser get user => _authService.currentUser;
  bool get isAuthenticated => user != null;
  void generateDataAndGreeting() => _utilService.generateDateAndGreeting();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authService, _utilService];

}