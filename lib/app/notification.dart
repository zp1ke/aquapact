import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../model/target_settings.dart';
import '../util/date_time.dart';

class AppNotification {
  static final AppNotification _instance = AppNotification._();

  static AppNotification get I => _instance;

  final plugin = FlutterLocalNotificationsPlugin();

  bool initialized = false;

  AppNotification._();

  AndroidFlutterLocalNotificationsPlugin? get androidPlugin =>
      plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  Future<bool> initialize() async {
    if (initialized) {
      return false;
    }

    initialized = true;

    tz.initializeTimeZones();

    final settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/app_icon'),
    );
    await plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) {},
    );

    final launchDetails = await plugin.getNotificationAppLaunchDetails();
    return launchDetails?.didNotificationLaunchApp ?? false;
  }

  Future<bool> hasPermissionGranted() async {
    final enabled = await androidPlugin?.areNotificationsEnabled();
    return enabled ?? false;
  }

  Future<bool> requestPermissions() async {
    final enabled = await androidPlugin?.requestNotificationsPermission();
    return enabled ?? false;
  }

  Future<void> scheduleNotificationsOf(
    TargetSettings targetSettings, {
    required String title,
    required String message,
  }) async {
    await plugin.cancelAll();
    var time = targetSettings.wakeUpTime;
    while (time.isBefore(targetSettings.sleepTime)) {
      await _scheduleDailyNotification(
        time.hour * 60 + time.minute,
        title,
        message,
        time,
      );
      time = time.add(targetSettings.notificationInterval);
    }
  }

  Future<void> _scheduleDailyNotification(
    int id,
    String title,
    String message,
    TimeOfDay time,
  ) async {
    await plugin.zonedSchedule(
      id,
      title,
      message,
      _convertTime(time),
      NotificationDetails(android: _androidDetails()),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  AndroidNotificationDetails _androidDetails() {
    return AndroidNotificationDetails(
      'aquapact_channel',
      'AquaPact Notifications',
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      enableLights: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList(<int>[1000, 500, 1000]),
    );
  }

  tz.TZDateTime _convertTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }
}
