import 'package:flutter/material.dart';

extension ActionBarExtension on Widget {
  addActionBar({Widget leading, Widget title, Widget subtitle, Widget trailing}) => Container(
    height: kToolbarHeight,
    child: NavigationToolbar(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: leading,
      ),
      middle: title,
      trailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: trailing,
      ),
    ),
  );
}