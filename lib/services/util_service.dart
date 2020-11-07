import 'dart:math';

import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:workout_progress/shared/constants.dart';

class UtilService {

  String today;
  String greeting;
  
  generateDateAndGreeting() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMMMMd();
    today = formatter.format(now);
    greeting = greetings[Random().nextInt(greetings.length)];
  }

  String getDisplayTime(int milliseconds) {
    bool showHours = milliseconds > (60*60*60);
    return StopWatchTimer.getDisplayTime(milliseconds, hours: showHours, milliSecond: false);
  }
}