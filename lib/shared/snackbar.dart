import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/shared/constants.dart';

import '../locator.dart';
import '../shared/theme.dart';

enum SnackbarType { darkTop, lightTop }

setUpCustomSnackbarUI() {
  SnackbarService snackbarService = locator<SnackbarService>();

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarType.lightTop,
    config: SnackbarConfig(
      isDismissible: false,
      backgroundColor: lightTheme.snackBarTheme.backgroundColor,
      textColor: lightTheme.snackBarTheme.contentTextStyle.color,
      mainButtonTextColor: lightTheme.snackBarTheme.actionTextColor,
      borderWidth: 2.0,
      borderColor: snackbarBorderColorLight,
      snackPosition: SnackPosition.TOP,
      borderRadius: 10.0,
      margin: const EdgeInsets.all(16.0)
    ),
  );

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarType.darkTop,
    config: SnackbarConfig(
      isDismissible: false,
      backgroundColor: darkTheme.snackBarTheme.backgroundColor,
      textColor: darkTheme.snackBarTheme.contentTextStyle.color,
      mainButtonTextColor: darkTheme.snackBarTheme.actionTextColor,
      borderWidth: 2.0,
      borderColor: snackbarBorderColorDark,
      snackPosition: SnackPosition.TOP,
      borderRadius: 10.0,
      margin: const EdgeInsets.all(16.0),
    ),
  );
}
