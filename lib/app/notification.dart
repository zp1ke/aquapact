import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  AndroidNotificationDetails _androidDetails() {
    return AndroidNotificationDetails(
      'default_notification_channel',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      enableLights: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList(<int>[1000, 500, 1000]),
    );
  }

  Future<void> showNotification(
    int id,
    String title,
    String message, {
    String? payload,
  }) async {
    await plugin.show(
      id,
      title,
      message,
      NotificationDetails(android: _androidDetails()),
      payload: payload,
    );
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String message,
    DateTime dateTime,
  ) async {
    await plugin.cancelAll();
    await plugin.zonedSchedule(
      id,
      title,
      message,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(android: _androidDetails()),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }
}
