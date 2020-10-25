import 'package:adaptive_theme/src/adaptive_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/shared/theme.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../locator.dart';

enum DialogType {
  Basic,
  Confirm,
  Retry,
}

setUpCustomDialogUI(AdaptiveThemeMode savedThemeMode) {
  DialogService dialogService = locator<DialogService>();
  ThemeData themeData = savedThemeMode.isDark ? darkTheme : lightTheme;

  // Retry Dialog
  dialogService.registerCustomDialogBuilder(
    variant: DialogType.Retry,
    builder: (BuildContext context, DialogRequest dialogRequest) => Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              dialogRequest.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              dialogRequest.description,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              // Complete the dialog when you're done with it to return some data
              onTap: () => dialogService.completeDialog(
                DialogResponse(confirmed: true),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeData.buttonColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: dialogRequest.showIconInMainButton,
                        child: CustomAwesomeIcon(
                            icon: FontAwesomeIcons.redoAlt)),
                    Visibility(
                        visible: dialogRequest.showIconInMainButton,
                        child: SizedBox(
                          width: 12,
                        )),
                    Text(
                      dialogRequest.mainButtonTitle,
                      style: themeData.textTheme.button,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );

  /* dialogService.registerCustomDialogBuilder(
    variant: DialogType.Confirm,
    builder: (BuildContext context, DialogRequest dialogRequest) => Dialog(
      child: // Build your UI here //
    ),
  ); */
}
