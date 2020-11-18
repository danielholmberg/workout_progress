library progress_dashboard_view;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/extensions.dart';

import 'progress_dashboard_view_model.dart';

part 'progress_dashboard_view_[mobile].dart';

class ProgressDashboardView extends StatelessWidget {
  const ProgressDashboardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProgressDashboardViewModel>.reactive(
      viewModelBuilder: () => ProgressDashboardViewModel(),
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => _ProgressDashboardViewMobile(),
        );
      },
    );
  }
}
