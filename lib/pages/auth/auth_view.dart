library auth_page;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/pages/auth/auth_view_model.dart';

import '../../locator.dart';
import '../../services/firebase/auth.dart';
import '../../shared/constants.dart';
import '../../shared/widgets/custom_awesome_icon.dart';
import '../../shared/widgets/custom_raised_button.dart';
import '../home/home_view.dart';

part 'auth_view_[desktop].dart';
part 'auth_view_[mobile].dart';

class AuthView extends StatelessWidget {
  AuthView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      onModelReady: (model) => model.initialise(),
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        if (model.isAuthenticated) {
          return HomeView();
        } else {
          return ScreenTypeLayout.builder(
            mobile: (BuildContext context) => _AuthViewMobile(),
            desktop: (BuildContext context) => _AuthViewDesktop(),
          );
        }
      },
    );
  }
}
