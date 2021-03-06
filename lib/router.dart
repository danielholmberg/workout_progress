import 'package:flutter/material.dart';
import 'package:workout_progress/pages/workout/new_workout/new_workout_view.dart';

import 'models/workout_model.dart';
import 'pages/auth/auth_view.dart';
import 'pages/home/home_view.dart';
import 'pages/settings/settings_view.dart';
import 'pages/workout/workout_view.dart';

class MyRouter {

  static const String authRoute = '/';
  static const String homeRoute = 'home';
  static const String settingsRoute = 'settings';
  static const String workoutRoute = 'workout';
  static const String newWorkoutRoute = 'newWorkout';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authRoute:
        return MaterialPageRoute(builder: (_) => AuthView());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => SettingsView());
      case workoutRoute:
        Workout workout = settings.arguments;
        return MaterialPageRoute(builder: (_) => WorkoutView(workout: workout));
      case newWorkoutRoute:
        return MaterialPageRoute(builder: (_) => NewWorkoutView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
