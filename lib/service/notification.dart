import 'package:flutter/material.dart';

import '../model/target_settings.dart';
import '../util/date_time.dart';

abstract class NotificationService {
  /// returns true if the app was launched by a notification.
  bool get appLaunchedByNotification;

  Future<bool> hasPermissionGranted();

  Future<void> scheduleNotificationsOf(
    TargetSettings targetSettings, {
    required String title,
    required String message,
  }) async {
    await cancelAll();
    var time = targetSettings.wakeUpTime;
    while (!time.isAfter(targetSettings.sleepTime)) {
      await scheduleDailyNotification(
        time.hour * 60 + time.minute,
        title: title,
        message: message,
        time: time,
      );
      time = time.add(targetSettings.notificationInterval);
    }
  }

  Future<void> scheduleDailyNotification(
    int id, {
    required String title,
    required String message,
    required TimeOfDay time,
  });

  Future<void> cancelAll();
}
