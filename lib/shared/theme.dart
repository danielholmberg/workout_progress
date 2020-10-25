library theme;

import 'package:flutter/material.dart';
import 'package:workout_progress/shared/constants.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Dosis',
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: primarySwatchLight,
  backgroundColor: backgroundColorLight,
  accentColor: Colors.white,
  buttonColor: primaryColorLight,
  textTheme: TextTheme(
    headline1: TextStyle(
      color: titleTextColorLight,
      fontWeight: FontWeight.w900,
      fontSize: titleFontSize,
    ),
    headline2: TextStyle(
      color: titleTextColorLight,
      fontWeight: FontWeight.w700,
      fontSize: pageTitleFontSize,
    ),
    caption: TextStyle(
      color: captionTextColorLight,
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
    ),
    button: TextStyle(
      color: buttonTextColorLight,
      fontWeight: FontWeight.w700,
      fontSize: buttonFontSize,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: snackbarBackgroundColorLight,
    contentTextStyle: TextStyle(
      color: snackbarContentTextColorLight,
    ),
    actionTextColor: snackbarActionTextColorLight,
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Dosis',
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: primaryColorDark,
  backgroundColor: backgroundColorDark,
  accentColor: Colors.white,
  buttonColor: primaryColorDark,
  textTheme: TextTheme(
    headline1: TextStyle(
      color: titleTextColorDark,
      fontWeight: FontWeight.w900,
      fontSize: titleFontSize,
    ),
    headline2: TextStyle(
      color: titleTextColorDark,
      fontWeight: FontWeight.w700,
      fontSize: pageTitleFontSize,
    ),
    caption: TextStyle(
      color: captionTextColorDark,
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
    ),
    button: TextStyle(
      color: buttonTextColorDark,
      fontWeight: FontWeight.w700,
      fontSize: buttonFontSize,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: snackbarBackgroundColorDark,
    contentTextStyle: TextStyle(
      color: snackbarContentTextColorDark,
    ),
    actionTextColor: snackbarActionTextColorDark,
  ),
);