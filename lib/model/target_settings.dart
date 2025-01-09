import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../app/settings.dart';
import 'measure_unit.dart';

part 'target_settings.g.dart';

const _settingsKey = 'target_settings';

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

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  String toJson(TimeOfDay object) => '${object.hour}:${object.minute}';
}
