part of 'settings_view.dart';

class _SettingsViewMobile extends ViewModelWidget<SettingsViewModel> {
  const _SettingsViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, SettingsViewModel model) {
    final ThemeData themeData = Theme.of(context);

    _buildAppBar() {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeData.backgroundColor,
        centerTitle: true,
        title: Text(
          'Settings',
          style: themeData.textTheme.headline2,
        ),
      );
    }

    _buildBottomBar() {
      return BottomAppBar(
        color: themeData.backgroundColor,
        child: addActionBar(
          leading: IconButton(
            icon: CustomAwesomeIcon(
              icon: FontAwesomeIcons.arrowLeft,
              color: themeData.buttonColor,
            ),
            onPressed: model.onBackPress,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: ListView(
            children: [
              ListTile(
                title: Text('Theme Mode'),
                subtitle: Text('Toggle between Light and Dark mode'),
                trailing: Switch(
                  value: model.isDarkTheme,
                  onChanged: model.onToggleTheme,
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
                onTap: () async => await model.onSignOut(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}
