import 'package:flutter/material.dart';

import 'measure_unit.dart';
import 'sync_status.dart';

class Intake {
  final String code;
  final double amount;
  final DateTime dateTime;
  final VolumeMeasureUnit measureUnit;
  final SyncStatus healthSync;

  Intake({
    required this.code,
    required this.amount,
    required this.dateTime,
    required this.measureUnit,
    required this.healthSync,
  });

  TimeOfDay get timeOfDay => TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      );

  get isHealthSynced => SyncStatus.synced == healthSync;

  Intake copyWith({
    double? amount,
    TimeOfDay? timeOfDay,
    SyncStatus? healthSync,
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
      healthSync: healthSync ?? this.healthSync,
    );
  }
}
