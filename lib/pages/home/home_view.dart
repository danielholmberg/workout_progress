library home_page;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

part 'home_view_desktop.dart';
part 'home_view_mobile.dart';
part 'home_view_tablet.dart';
part 'home_view_watch.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => _HomeViewMobile(),
        tablet: (BuildContext context) => _HomeViewTablet(),
        desktop: (BuildContext context) => _HomeViewDesktop(),
        watch: (BuildContext context) => _HomeViewWatch(),
      ),
    );
  }
}
