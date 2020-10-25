import 'dart:math';

import 'package:intl/intl.dart';
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
}