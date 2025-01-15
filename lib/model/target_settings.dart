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

  @TimeOfDayConverter()
  final TimeOfDay wakeUpTime;

  @TimeOfDayConverter()
  final TimeOfDay sleepTime;

  final int notificationIntervalInMinutes;

  const TargetSettings({
    this.dailyTarget = 2500.0,
    this.volumeMeasureUnit = VolumeMeasureUnit.ml,
    this.wakeUpTime = const TimeOfDay(hour: 7, minute: 0),
    this.sleepTime = const TimeOfDay(hour: 23, minute: 0),
    this.notificationIntervalInMinutes = 60,
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
        wakeUpTime,
        sleepTime,
        notificationIntervalInMinutes,
      ];

  TargetSettings copyWith({
    double? dailyTarget,
    VolumeMeasureUnit? volumeMeasureUnit,
    TimeOfDay? wakeUpTime,
    TimeOfDay? sleepTime,
    int? notificationIntervalInMinutes,
  }) {
    return TargetSettings(
      dailyTarget: dailyTarget ?? this.dailyTarget,
      volumeMeasureUnit: volumeMeasureUnit ?? this.volumeMeasureUnit,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      sleepTime: sleepTime ?? this.sleepTime,
      notificationIntervalInMinutes:
          notificationIntervalInMinutes ?? this.notificationIntervalInMinutes,
    );
  }
}
