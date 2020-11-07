import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/shared/constants.dart';

import '../locator.dart';
import '../shared/theme.dart';

enum SnackbarType {
  DARK_TOP,
  LIGHT_TOP,
  DARK_BOTTOM,
  LIGHT_BOTTOM,
}

setUpCustomSnackbarUI() {
  SnackbarService snackbarService = locator<SnackbarService>();

  _topConfig(bool isDark) {
    ThemeData theme = isDark ? darkTheme : lightTheme;
    return SnackbarConfig(
      isDismissible: false,
      backgroundColor: theme.snackBarTheme.backgroundColor,
      textColor: theme.snackBarTheme.contentTextStyle.color,
      mainButtonTextColor: theme.snackBarTheme.actionTextColor,
      borderWidth: 2.0,
      borderColor: isDark ? snackbarBorderColorDark : snackbarBorderColorLight,
      snackPosition: SnackPosition.TOP,
      borderRadius: 10.0,
      margin: const EdgeInsets.all(16.0),
    );
  }

  _bottomConfig(bool isDark) {
    ThemeData theme = isDark ? darkTheme : lightTheme;
    return SnackbarConfig(
      isDismissible: false,
      backgroundColor: theme.snackBarTheme.backgroundColor,
      textColor: theme.snackBarTheme.contentTextStyle.color,
      mainButtonTextColor: theme.snackBarTheme.actionTextColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarType.LIGHT_TOP,
    config: _topConfig(false),
  );

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarType.DARK_TOP,
    config: _topConfig(true),
  );

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarType.LIGHT_BOTTOM,
    config: _bottomConfig(false),
  );

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarType.DARK_BOTTOM,
    config: _bottomConfig(true),
  );
}
