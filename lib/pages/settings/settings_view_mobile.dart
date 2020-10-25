part of 'settings_view.dart';

class _SettingsViewMobile extends StatelessWidget {
  const _SettingsViewMobile({Key key}) : super(key: key);

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
          child: ListView(
            children: [
              ListTile(
                title: Text('Theme mode'),
                subtitle: Text('Toggle between Light and Dark mode'),
                trailing: Switch(
                  value: AdaptiveTheme.of(context).mode.isDark,
                  onChanged: (value) =>
                      AdaptiveTheme.of(context).toggleThemeMode(),
                ),
              ),
            ],
          ),
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
          'Settings',
          style: themeData.textTheme.headline2,
        ),
      ),
    );
  }
}
