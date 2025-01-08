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

class TargetSettings {
  double dailyTarget = 2500.0;

  VolumeMeasureUnit volumeMeasureUnit = VolumeMeasureUnit.ml;

  TimeOfDay wakeUpTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay sleepTime = const TimeOfDay(hour: 23, minute: 0);

  int notificationIntervalInMinutes = 60;

  Duration get notificationInterval =>
      Duration(minutes: notificationIntervalInMinutes);

  Future<bool> save() async {
    final appSettings = await AppSettings.I;
    return appSettings.write(_settingsKey, _toMap());
  }

  static Future<TargetSettings?> read() async {
    final appSettings = await AppSettings.I;
    final Map<String, dynamic>? map = appSettings.read(_settingsKey);
    if (map != null) {
      return _fromMap(map);
    }
    return null;
  }

  static TargetSettings _fromMap(Map<String, dynamic> map) {
    final settings = TargetSettings();
    settings.dailyTarget =
        map[_dailyTargetKey] as double? ?? settings.dailyTarget;
    settings.volumeMeasureUnit =
        VolumeMeasureUnit.values[map[_volumeMeasureUnitKey] as int? ?? 0];
    settings.wakeUpTime = TimeOfDay(
      hour: map[_wakeUpTimeHourKey] as int? ?? settings.wakeUpTime.hour,
      minute: map[_wakeUpTimeMinuteKey] as int? ?? settings.wakeUpTime.minute,
    );
    settings.sleepTime = TimeOfDay(
      hour: map[_sleepTimeHourKey] as int? ?? settings.sleepTime.hour,
      minute: map[_sleepTimeMinuteKey] as int? ?? settings.sleepTime.minute,
    );
    settings.notificationIntervalInMinutes =
        map[_notificationIntervalKey] as int? ??
            settings.notificationIntervalInMinutes;
    return settings;
  }

  Map<String, dynamic> _toMap() {
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
}
