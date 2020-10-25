part of 'workout_view.dart';

class _WorkoutViewMobile extends StatelessWidget {
  final Workout workout;
  const _WorkoutViewMobile({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final FirebaseAuthService authService = locator<FirebaseAuthService>();
    final NavigationService navigationService = locator<NavigationService>();
    final SnackbarService snackbarService = locator<SnackbarService>();
    final UtilService utilService = locator<UtilService>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Center(child: Text(workout.duration.toString())),
        ),
      ),
      bottomNavigationBar: addActionBar(
        leading: IconButton(
          icon: CustomAwesomeIcon(
            icon: FontAwesomeIcons.arrowLeft,
            color: themeData.buttonColor,
          ),
          onPressed: () => navigationService.back(),
        ),
        title: Text(
          workout.name,
          style: themeData.textTheme.headline2,
        ),
        trailing: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: CustomAwesomeIcon(
                icon: FontAwesomeIcons.check,
                color: themeData.buttonColor,
              ),
              onPressed: () => snackbarService.showCustomSnackBar(
                variant: themeData.brightness == Brightness.dark ? SnackbarType.darkTop : SnackbarType.lightTop,
                message: 'Good job finishing the workout!',
                title: 'Workout saved',
                duration: Duration(seconds: 2),
                onTap: (_) {
                  print('snackbar tapped');
                },
                mainButtonTitle: 'Dismiss',
                onMainButtonTapped: () => print('Dismissed snackbar!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
