import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';
import 'pages/auth/auth_view.dart';
import 'router.dart';
import 'shared/dialogs.dart';
import 'shared/snackbar.dart';
import 'shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode savedThemeMode = await AdaptiveTheme.getThemeMode();
  setUpLocator(); // get_it
  setUpCustomDialogUI();
  setUpCustomSnackbarUI();
  runApp(
    Main(savedThemeMode: savedThemeMode),
    /* 
      // See pubspec.yaml for mor info.
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(),
      ),
      */
  );
}

class Main extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;
  Main({this.savedThemeMode});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Workout Progress',
        theme: theme,
        darkTheme: darkTheme,
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: MyRouter.generateRoute,
        initialRoute: MyRouter.authRoute,
        //locale: DevicePreview.of(context).locale,
        //builder: DevicePreview.appBuilder,
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return AuthView();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
