library settings_page;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/pages/settings/settings_view_model.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../locator.dart';
import '../../services/firebase/auth.dart';
import '../../services/util_service.dart';
import '../../shared/constants.dart';
import '../../shared/extensions.dart';

part 'settings_view_[desktop].dart';
part 'settings_view_[mobile].dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onModelReady: (model) => model.initialise(context),
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => _SettingsViewMobile(),
          desktop: (BuildContext context) => _SettingsViewDesktop(),
        );
      },
    );
  }
}
