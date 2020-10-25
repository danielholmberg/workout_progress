import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import 'services/firebase/auth.dart';
import 'services/firebase/firestore.dart';
import 'services/util_service.dart';
import 'services/workout_service.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<FirebaseFirestoreService>(() => FirebaseFirestoreService());
  locator.registerLazySingleton<WorkoutService>(() => WorkoutService());
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerSingleton<UtilService>(UtilService());
}