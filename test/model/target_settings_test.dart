import 'package:aquapact/model/target_settings.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  test('TargetSettings.toMap() generates parseable map', () {
    final settings = TargetSettings(
      dailyTarget: 3000.0,
      wakeUpTime: const TimeOfDay(hour: 6, minute: 30),
      sleepTime: const TimeOfDay(hour: 22, minute: 30),
      notificationIntervalInMinutes: 45,
    );
    final settingsMap = settings.toMap();
    expect(settingsMap, isNotNull);

    final parsedSettings = TargetSettings.fromMap(settingsMap);
    expect(parsedSettings, equals(settings));
  });
}
