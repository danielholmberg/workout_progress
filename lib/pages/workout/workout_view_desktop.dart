part of 'workout_view.dart';

class _WorkoutViewDesktop extends StatelessWidget {
  final Workout workout;
  final StopWatchTimer stopWatch;
  const _WorkoutViewDesktop({
    Key key,
    this.workout,
    this.stopWatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final FirebaseAuthService authService = locator<FirebaseAuthService>();
    final UtilService utilService = locator<UtilService>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.green,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        utilService.today,
                        style: themeData.textTheme.caption,
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () =>
                            AdaptiveTheme.of(context).toggleThemeMode(),
                        child: authService.currentUserAvatar,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
