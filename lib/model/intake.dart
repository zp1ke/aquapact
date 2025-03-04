import 'package:flutter/material.dart';

import 'measure_unit.dart';

class Intake {
  final String code;
  final double amount;
  final DateTime dateTime;
  final VolumeMeasureUnit measureUnit;
  final bool healthSynced;

  Intake({
    required this.code,
    required this.amount,
    required this.dateTime,
    required this.measureUnit,
    this.healthSynced = false,
  });

  TimeOfDay get timeOfDay => TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      );

  Intake copyWith({
    double? amount,
    TimeOfDay? timeOfDay,
    bool? healthSynced,
  }) {
    var dateTime = this.dateTime.copyWith();
    if (timeOfDay != null) {
      dateTime = dateTime.copyWith(
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
      );
    }
    return Intake(
      code: code,
      amount: amount ?? this.amount,
      dateTime: dateTime,
      measureUnit: measureUnit,
      healthSynced: healthSynced ?? this.healthSynced,
    );
  }
}
