library home_page;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:workout_progress/pages/home/home_view_model.dart';
import 'package:workout_progress/pages/home/widgets/workout_list_view_model.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../shared/constants.dart';
import '../../shared/extensions.dart';
import 'widgets/workout_list_view.dart';

part 'home_view_[desktop].dart';
part 'home_view_[mobile].dart';
part 'home_view_[tablet].dart';
part 'home_view_[watch].dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.nonReactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => _HomeViewMobile(),
          tablet: (BuildContext context) => _HomeViewTablet(),
          desktop: (BuildContext context) => _HomeViewDesktop(),
          watch: (BuildContext context) => _HomeViewWatch(),
        );
      },
    );
  }
}