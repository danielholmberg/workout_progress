library home_page;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../../pages/home/widget/workouts_list.dart';
import '../../router.dart';
import '../../services/firebase/auth.dart';
import '../../services/util_service.dart';
import '../../shared/constants.dart';
import '../../shared/widgets/custom_awesome_icon.dart';

part 'home_view_desktop.dart';
part 'home_view_mobile.dart';
part 'home_view_tablet.dart';
part 'home_view_watch.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => _HomeViewMobile(),
      tablet: (BuildContext context) => _HomeViewTablet(),
      desktop: (BuildContext context) => _HomeViewDesktop(),
      watch: (BuildContext context) => _HomeViewWatch(),
    );
  }
}
