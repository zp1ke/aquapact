import 'package:flutter/material.dart';

import '../app/di.dart';
import '../model/notification.dart';
import '../model/target_settings.dart';
import '../util/date_time.dart';

abstract class NotificationService {
  static NotificationService get() => service<NotificationService>();

  /// returns true if the app was launched by a notification.
  bool get appLaunchedByNotification;

  Future<bool> hasPermissionGranted();

  Future<void> scheduleNotificationsOf(
    TargetSettings targetSettings, {
    required String title,
    required String message,
  }) async {
    await cancelAll();
    var dateTime = targetSettings.wakeUpTime.toDateTime();
    final sleepDateTime = targetSettings.sleepTime.toDateTime();
    while (!dateTime.isAfter(sleepDateTime)) {
      final time = TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      );
      final notification = AppNotification(
        id: time.hour * 60 + time.minute,
        title: title,
        body: message,
        time: time,
      );
      await scheduleDailyNotification(notification);
      dateTime = dateTime.add(targetSettings.notificationInterval);
    }
  }

  Future<void> scheduleDailyNotification(AppNotification notification);

  Future<void> cancelAll();

  Future<List<AppNotification>> nextNotifications();
}
