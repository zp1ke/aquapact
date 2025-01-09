import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../app/settings.dart';
import 'measure_unit.dart';

const _settingsKey = 'target_settings';
const _dailyTargetKey = 'daily_target';
const _volumeMeasureUnitKey = 'volume_measure_unit';
const _wakeUpTimeHourKey = 'wake_up_time_hour';
const _wakeUpTimeMinuteKey = 'wake_up_time_minute';
const _sleepTimeHourKey = 'sleep_time_hour';
const _sleepTimeMinuteKey = 'sleep_time_minute';
const _notificationIntervalKey = 'notification_interval';

class TargetSettings extends Equatable {
  final double dailyTarget;

  final VolumeMeasureUnit volumeMeasureUnit;

  final TimeOfDay wakeUpTime;
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

  Future<bool> save() async {
    final appSettings = await AppSettings.I;
    return appSettings.write(_settingsKey, toMap());
  }

  static Future<TargetSettings?> read() async {
    final appSettings = await AppSettings.I;
    final Map<String, dynamic>? map = appSettings.read(_settingsKey);
    if (map != null) {
      return TargetSettings.fromMap(map);
    }
    return null;
  }

  factory TargetSettings.fromMap(Map<String, dynamic> map) {
    final settings = TargetSettings(
      dailyTarget: map[_dailyTargetKey] as double? ?? 2500.0,
      volumeMeasureUnit:
          VolumeMeasureUnit.values[map[_volumeMeasureUnitKey] as int? ?? 0],
      wakeUpTime: TimeOfDay(
        hour: map[_wakeUpTimeHourKey] as int? ?? 6,
        minute: map[_wakeUpTimeMinuteKey] as int? ?? 0,
      ),
      sleepTime: TimeOfDay(
        hour: map[_sleepTimeHourKey] as int? ?? 23,
        minute: map[_sleepTimeMinuteKey] as int? ?? 0,
      ),
      notificationIntervalInMinutes:
          map[_notificationIntervalKey] as int? ?? 60,
    );
    return settings;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _dailyTargetKey: dailyTarget,
      _volumeMeasureUnitKey: volumeMeasureUnit.index,
      _wakeUpTimeHourKey: wakeUpTime.hour,
      _wakeUpTimeMinuteKey: wakeUpTime.minute,
      _sleepTimeHourKey: sleepTime.hour,
      _sleepTimeMinuteKey: sleepTime.minute,
      _notificationIntervalKey: notificationIntervalInMinutes,
    };
  }

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
