import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../model/notification.dart';
import '../notification.dart';

class LocalNotificationService extends NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool? _appLaunchedByNotification;

  LocalNotificationService._(this._plugin);

  static Future<NotificationService> create() async {
    final plugin = FlutterLocalNotificationsPlugin();
    final service = LocalNotificationService._(plugin);
    await service._initialize();
    return service;
  }

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  Future<void> _initialize() async {
    tz.initializeTimeZones();

    final settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/notification_icon'),
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
    var enabled = await _androidPlugin?.requestNotificationsPermission();
    if (enabled == true) {
      enabled = await _androidPlugin?.requestExactAlarmsPermission();
    }
    return enabled ?? false;
  }

  @override
  Future<void> scheduleDailyNotification(AppNotification notification) async {
    final dateTime = _convertTime(notification.time);
    debugPrint('Scheduling notification for ${notification.time} at $dateTime');
    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      dateTime,
      payload: jsonEncode(notification.toMap()),
      NotificationDetails(android: _androidDetails()),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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

  @override
  Future<void> cancelAll() {
    return _plugin.cancelAll();
  }

  @override
  Future<List<AppNotification>> nextNotifications() async {
    final notifications = await _plugin.pendingNotificationRequests();
    return notifications
        .where((notification) => notification.payload != null)
        .map((notification) =>
            AppNotification.fromMap(jsonDecode(notification.payload!)))
        .toList(growable: false);
  }
}
