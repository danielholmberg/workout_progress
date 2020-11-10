library theme;

import 'package:flutter/material.dart';
import 'package:workout_progress/shared/constants.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Dosis',
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: primaryColorLight,
  primarySwatch: primarySwatchLight,
  backgroundColor: backgroundColorLight,
  accentColor: Colors.white,
  buttonColor: primaryColorLight,
  hintColor: primaryColorLight.withOpacity(0.5),
  iconTheme: IconThemeData(
    color: primaryColorLight,
  ),
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
    headline3: TextStyle(
      color: titleTextColorLight,
      fontWeight: FontWeight.w700,
      fontSize: exerciseNameFontSize,
    ),
    caption: TextStyle(
      color: captionTextColorLight,
      fontWeight: FontWeight.bold,
      fontSize: captionFontSize,
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
  primaryColor: primaryColorDark,
  primarySwatch: primarySwatchDark,
  backgroundColor: backgroundColorDark,
  accentColor: Colors.white,
  buttonColor: primaryColorDark,
  hintColor: primaryColorDark.withOpacity(0.5),
  iconTheme: IconThemeData(
    color: primaryColorDark,
  ),
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
    headline3: TextStyle(
      color: titleTextColorDark,
      fontWeight: FontWeight.w700,
      fontSize: exerciseNameFontSize,
    ),
    caption: TextStyle(
      color: captionTextColorDark,
      fontWeight: FontWeight.bold,
      fontSize: captionFontSize,
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