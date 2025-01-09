import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../model/target_settings.dart';
import '../../util/date_time.dart';
import '../notification.dart';

class LocalNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool? _appLaunchedByNotification;

  LocalNotificationService._(this._plugin);

  static Future<NotificationService> create() async {
    final plugin = FlutterLocalNotificationsPlugin();
    final service = LocalNotificationService._(plugin);
    await service._initialize();
    return service;
  }

  AndroidFlutterLocalNotificationsPlugin? get androidPlugin =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  Future<void> _initialize() async {
    tz.initializeTimeZones();

    final settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/app_icon'),
    );
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) {},
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    _appLaunchedByNotification =
        launchDetails?.didNotificationLaunchApp ?? false;
  }

  @override
  bool get appLaunchedByNotification => _appLaunchedByNotification ?? false;

  @override
  Future<bool> hasPermissionGranted() async {
    final enabled = await androidPlugin?.areNotificationsEnabled();
    return enabled ?? false;
  }

  @override
  Future<bool> requestPermissions() async {
    final enabled = await androidPlugin?.requestNotificationsPermission();
    return enabled ?? false;
  }

  @override
  Future<void> scheduleNotificationsOf(
    TargetSettings targetSettings, {
    required String title,
    required String message,
  }) async {
    await _plugin.cancelAll();
    var time = targetSettings.wakeUpTime;
    while (!time.isAfter(targetSettings.sleepTime)) {
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
    final dateTime = _convertTime(time);
    debugPrint('Scheduling notification for $time at $dateTime');
    await _plugin.zonedSchedule(
      id,
      title,
      message,
      dateTime,
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
    return tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
  }
}
