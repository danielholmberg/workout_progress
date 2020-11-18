part of 'progress_dashboard_view.dart';

class _ProgressDashboardViewMobile
    extends ViewModelWidget<ProgressDashboardViewModel> {
  const _ProgressDashboardViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProgressDashboardViewModel model) {
    final ThemeData themeData = Theme.of(context);

    _buildProgressChart(BaseExercise baseExercise) {
      List<LineChartBarData> lineBarsData = [
        LineChartBarData(
          spots: model.generateSpots(baseExercise.id),
          isCurved: true,
          curveSmoothness: 0.2,
          colors: [
            themeData.accentColor.withOpacity(0.5),
            themeData.accentColor.withOpacity(0.6),
            themeData.accentColor.withOpacity(0.8),
            themeData.accentColor,
          ],
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
        ),
      ];

      return LineChart(
        LineChartData(
          minX: model.minValueX,
          maxX: model.maxValueX,
          minY: model.minValueY,
          maxY: model.maxValueY,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: false,
          ),
          lineBarsData: lineBarsData,
          lineTouchData: LineTouchData(
            enabled: true,
            getTouchedSpotIndicator: (barData, indicators) {
              return indicators.map((int index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: themeData.accentColor.withOpacity(0.8),
                    strokeWidth: 2,
                  ),
                  FlDotData(
                    getDotPainter: (
                      spot,
                      percent,
                      bar,
                      index,
                    ) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: themeData.primaryColor.withOpacity(0.8),
                        strokeColor: themeData.accentColor,
                      );
                    },
                  ),
                );
              }).toList();
            },
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: themeData.accentColor,
              tooltipRoundedRadius: 10,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (List<LineBarSpot> lineBarSpots) {
                return lineBarSpots.map((spot) {
                  return LineTooltipItem(
                    spot.y.toString(),
                    themeData.textTheme.bodyText1.copyWith(
                      color: themeData.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      );
    }

    _buildDashItem(BaseExercise baseExercise) {
      return Card(
        color: themeData.primaryColor,
        elevation: 6.0,
        margin: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                baseExercise.name,
                style: themeData.textTheme.headline2.copyWith(
                  color: themeData.accentColor,
                ),
              ),
            ).withPadding(const EdgeInsets.only(top: defaultPadding)),
            Expanded(
              child: model.generateSpots(baseExercise.id).isEmpty
                  ? Center(
                      child: Text(
                        'Complete a set of ${baseExercise.name}\n to show progress here',
                        style: themeData.textTheme.button
                            .copyWith(color: Colors.white.withOpacity(0.9)),
                        textAlign: TextAlign.center,
                      ),
                    ).withPadding(const EdgeInsets.only(bottom: defaultPadding))
                  : _buildProgressChart(baseExercise).withPadding(
                      const EdgeInsets.all(defaultPadding * 2),
                    ),
            ),
          ],
        ),
      );
    }

    return Container(
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: model.baseExercisesCount,
        itemBuilder: (context, index) => _buildDashItem(
          model.getBaseExercise(index),
        ),
      ),
    );
  }
}
