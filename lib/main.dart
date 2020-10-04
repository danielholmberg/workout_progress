import 'package:flutter/material.dart';
import 'package:template_flutter/pages/home/home_view.dart';

import 'locator.dart';

void main() { 
  setUpLocator(); // get_it
  runApp(
    Root(),
    /* 
    // See pubspec.yaml for mor info.
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
    */
  );
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Template: Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //locale: DevicePreview.of(context).locale,
      //builder: DevicePreview.appBuilder,
      home: HomeView(),
    );
  }
}