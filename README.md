# Workout Progress
Flutter application for following my own gym-workout progress

`keytool -list -v -alias WorkoutProgress -keystore ~/Development/Android/keystore`

# Structure
- **assets/**
- **lib/**
  - **models/**
  - **pages/**
    - **{functionality}/**
      - **widgets/**
      - {functionality}\_view_[desktop].dart
      - {functionality}\_view_[mobile].dart
      - {functionality}\_view_[tablet].dart
      - {functionality}\_view_[watch].dart
      - {functionality}_view_model.dart
      - {functionality}_view.dart
  - **services/**
  - **shared/**
  - locator.dart
  - main.dart
  - router.dart