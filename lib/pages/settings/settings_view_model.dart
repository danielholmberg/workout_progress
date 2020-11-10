import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/services/firebase/auth.dart';
import 'package:workout_progress/services/util_service.dart';
import 'package:workout_progress/shared/dialogs.dart';

import '../../locator.dart';

class SettingsViewModel extends BaseViewModel {
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final UtilService _utilService = locator<UtilService>();

  BuildContext _context;

  void initialise(BuildContext context) {
    _context = context;
  }

  bool get isDarkTheme => AdaptiveTheme.of(_context).mode.isDark;

  Future onSignOut() async {
    DialogResponse result = await _dialogService.showCustomDialog(
      variant: isDarkTheme ? DialogType.CONFIRM_DARK : DialogType.CONFIRM_LIGHT,
      title: 'Sign out',
      description: 'Are you sure you want to sign out?',
      mainButtonTitle: 'Yes',
      secondaryButtonTitle: 'No',
      showIconInMainButton: true,
      showIconInSecondaryButton: true,
    );

    if (result.confirmed) {
      await _authService.signOut();
      _navigationService.popUntil((route) => route.isFirst);
    }
  }

  void onBackPress() => _navigationService.back();

  void onToggleTheme(value) => AdaptiveTheme.of(_context).toggleThemeMode();
}
