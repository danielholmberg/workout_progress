import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';

class Loading extends StatelessWidget {
  final Color color;
  final double size;
  Loading({this.color = primaryColorLight, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        type: SpinKitWaveType.center,
        color: color,
        itemCount: 9,
        size: size,
      )
    );
  }
}
