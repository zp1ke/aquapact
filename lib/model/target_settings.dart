import 'package:flutter/material.dart';

import 'measure_unit.dart';

class TargetSettings {
  double dailyTarget = 2500.0;

  VolumeMeasureUnit volumeMeasureUnit = VolumeMeasureUnit.ml;

  TimeOfDay wakeUpTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay sleepTime = const TimeOfDay(hour: 23, minute: 0);

  int notificationIntervalInMinutes = 60;
}
