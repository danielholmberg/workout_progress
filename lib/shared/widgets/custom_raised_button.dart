import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_awesome_icon.dart';

class CustomRaisedButton extends StatelessWidget {
  final FocusNode focusNode;
  final Function onPressed;
  final String text;
  final Color color;
  final bool inverse;
  final CustomAwesomeIcon icon;
  CustomRaisedButton({
    @required this.onPressed,
    @required this.text,
    this.color,
    this.focusNode,
    this.inverse = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      focusNode: focusNode,
      color: inverse ? backgroundColorLight : color ?? primaryColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          icon != null ? icon : SizedBox.shrink(),
          Visibility(visible: icon != null, child: SizedBox(width: smallSpacing)),
          Text(
            text, 
            style: Theme.of(context).textTheme.button.copyWith(
              color: inverse ? primaryColorLight : buttonIconColorLight,
              fontWeight: FontWeight.bold,
            )
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}