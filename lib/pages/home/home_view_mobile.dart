part of 'home_view.dart';

class _HomeViewMobile extends StatelessWidget {
  const _HomeViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final FirebaseAuthService authService = locator<FirebaseAuthService>();
    final NavigationService navigationService = locator<NavigationService>();
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
                        onTap: () => navigationService.navigateTo(Router.settingsRoute),
                        child: authService.currentUserAvatar,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.red,
                  child: Text(
                    '${utilService.greeting} ${authService.currentUser.firstName}',
                    style: themeData.textTheme.headline1,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: WorkoutsList(),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton.extended(
                          backgroundColor: themeData.buttonColor,
                          foregroundColor: themeData.buttonColor,
                          onPressed: () async => await authService.signOut(),
                          icon: CustomAwesomeIcon(
                            icon: FontAwesomeIcons.signOutAlt,
                          ),
                          label: Text(
                            'Sign out',
                            style: themeData.textTheme.button,
                          ),
                        ),
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
