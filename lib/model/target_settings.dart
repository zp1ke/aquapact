import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../util/date_time.dart';
import 'measure_unit.dart';

part 'target_settings.g.dart';

@JsonSerializable()
class TargetSettings extends Equatable {
  final double dailyTarget;

  final VolumeMeasureUnit volumeMeasureUnit;

  final List<double> intakeValues;

  final double defaultIntakeValue;

  @TimeOfDayConverter()
  final TimeOfDay wakeUpTime;

  @TimeOfDayConverter()
  final TimeOfDay sleepTime;

  final int notificationIntervalInMinutes;

  final bool healthSync;

  const TargetSettings({
    this.dailyTarget = 2500.0,
    this.volumeMeasureUnit = .ml,
    this.intakeValues = const [100.0, 250.0, 400.0, 500.0],
    this.defaultIntakeValue = 250.0,
    this.wakeUpTime = const TimeOfDay(hour: 7, minute: 0),
    this.sleepTime = const TimeOfDay(hour: 23, minute: 0),
    this.notificationIntervalInMinutes = 60,
    this.healthSync = false,
  });

  Duration get notificationInterval =>
      Duration(minutes: notificationIntervalInMinutes);

  factory TargetSettings.fromMap(Map<String, dynamic> map) =>
      _$TargetSettingsFromJson(map);

  Map<String, dynamic> toMap() => _$TargetSettingsToJson(this);

  @override
  List<Object?> get props => [
    dailyTarget,
    volumeMeasureUnit,
    intakeValues,
    defaultIntakeValue,
    wakeUpTime,
    sleepTime,
    notificationIntervalInMinutes,
    healthSync,
  ];

  TargetSettings copyWith({
    double? dailyTarget,
    VolumeMeasureUnit? volumeMeasureUnit,
    List<double>? intakeValues,
    double? defaultIntakeValue,
    TimeOfDay? wakeUpTime,
    TimeOfDay? sleepTime,
    int? notificationIntervalInMinutes,
    bool? healthSync,
  }) {
    return TargetSettings(
      dailyTarget: dailyTarget ?? this.dailyTarget,
      volumeMeasureUnit: volumeMeasureUnit ?? this.volumeMeasureUnit,
      intakeValues: _intakeValues(intakeValues ?? this.intakeValues),
      defaultIntakeValue: defaultIntakeValue ?? this.defaultIntakeValue,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      sleepTime: sleepTime ?? this.sleepTime,
      notificationIntervalInMinutes:
          notificationIntervalInMinutes ?? this.notificationIntervalInMinutes,
      healthSync: healthSync ?? this.healthSync,
    );
  }

  List<double> _intakeValues(List<double> list) {
    if (list.isEmpty) {
      return [defaultIntakeValue];
    }
    var values = list.toSet().toList();
    values.sort();
    return values;
  }
}
