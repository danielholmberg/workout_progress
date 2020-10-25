library auth_page;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:workout_progress/models/user_model.dart';
import 'package:workout_progress/services/util_service.dart';

import '../../locator.dart';
import '../../services/firebase/auth.dart';
import '../../shared/constants.dart';
import '../../shared/widgets/custom_awesome_icon.dart';
import '../../shared/widgets/custom_raised_button.dart';
import '../home/home_view.dart';

part 'auth_view_desktop.dart';
part 'auth_view_mobile.dart';

class AuthView extends StatelessWidget {
  AuthView({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final MyUser currentUser = Provider.of<MyUser>(context);
    final bool authenticated = currentUser != null;

    if(authenticated) locator<UtilService>().generateDateAndGreeting();

    return authenticated ? HomeView() : ScreenTypeLayout.builder(
      mobile: (BuildContext context) => _AuthViewMobile(),
      desktop: (BuildContext context) => _AuthViewDesktop(),
    );
  }
}
