part of 'settings_view.dart';

class _SettingsViewMobile extends StatelessWidget {
  const _SettingsViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final FirebaseAuthService authService = locator<FirebaseAuthService>();
    final NavigationService navigationService = locator<NavigationService>();
    final DialogService dialogService = locator<DialogService>();
    final UtilService utilService = locator<UtilService>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeData.backgroundColor,
        centerTitle: true,
        title: Text(
          'Settings',
          style: themeData.textTheme.headline2,
        )
      ),
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
              ListTile(
                title: Text(
                  'Sign out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  DialogResponse result = await dialogService.showCustomDialog(
                    variant: AdaptiveTheme.of(context).mode.isDark ? DialogType.CONFIRM_DARK : DialogType.CONFIRM_LIGHT,
                    title: 'Sign out',
                    description: 'Are you sure you want to sign out?',
                    mainButtonTitle: 'Yes',
                    secondaryButtonTitle: 'No',
                    showIconInMainButton: true,
                    showIconInSecondaryButton: true,
                  );

                  if(result.confirmed) {
                    await authService.signOut();
                    navigationService.popUntil((route) => route.isFirst);
                  }
                },
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
      ),
    );
  }
}
