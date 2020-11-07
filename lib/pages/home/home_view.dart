library home_page;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../locator.dart';
import '../../pages/home/widget/workouts_list.dart';
import '../../router.dart';
import '../../services/firebase/auth.dart';
import '../../services/util_service.dart';
import '../../shared/constants.dart';
import '../../shared/extensions.dart';

part 'home_view_desktop.dart';
part 'home_view_mobile.dart';
part 'home_view_tablet.dart';
part 'home_view_watch.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseFirestoreService dbService = locator<FirebaseFirestoreService>();

  @override
  void initState() {
    dbService.setUpListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => dbService,
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => _HomeViewMobile(),
        tablet: (BuildContext context) => _HomeViewTablet(),
        desktop: (BuildContext context) => _HomeViewDesktop(),
        watch: (BuildContext context) => _HomeViewWatch(),
      ),
    );
  }
}
