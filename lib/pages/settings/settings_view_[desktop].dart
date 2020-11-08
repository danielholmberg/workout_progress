part of 'settings_view.dart';

class _SettingsViewDesktop extends StatelessWidget {
  const _SettingsViewDesktop({Key key}) : super(key: key);

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
