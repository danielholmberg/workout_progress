import 'dart:math';

import 'package:intl/intl.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:workout_progress/shared/constants.dart';

class UtilService with ReactiveServiceMixin {

  RxValue<String> _today = RxValue<String>(initial: '');
  RxValue<String> _greeting = RxValue<String>(initial: '');

  UtilService() {
    listenToReactiveValues([
      _today,
      _greeting,
    ]);
  }

  String get today => _today.value;
  String get greeting => _greeting.value;
  
  generateDateAndGreeting() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMMMMd();
    _today.value = formatter.format(now);
    _greeting.value = greetings[Random().nextInt(greetings.length)];
  }

  String getDisplayTime(int milliseconds) {
    bool showHours = milliseconds > (60*60*60);
    return StopWatchTimer.getDisplayTime(milliseconds, hours: showHours, milliSecond: false);
  }
}