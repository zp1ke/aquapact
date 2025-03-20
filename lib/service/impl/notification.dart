import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../model/notification.dart';
import '../../util/logger.dart';
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

  IOSFlutterLocalNotificationsPlugin? get _iosPlugin =>
      _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

  Future<void> _initialize() async {
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    'Timezone: ${tz.local.name}'.log();

    final settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/notification_icon'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) {},
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    _appLaunchedByNotification =
        launchDetails?.didNotificationLaunchApp ?? false;

    final pendingNotifications = await _plugin.pendingNotificationRequests();
    for (var notification in pendingNotifications) {
      'Pending notification: ${notification.title} ${notification.body} removed'
          .log();
      await _plugin.cancel(notification.id);
    }
  }

  @override
  bool get appLaunchedByNotification => _appLaunchedByNotification ?? false;

  @override
  Future<bool> hasPermissionGranted() async {
    var enabled =
        await _androidPlugin?.requestNotificationsPermission() ?? false;
    if (!enabled) {
      enabled = await _iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    if (enabled && _androidPlugin != null) {
      enabled = await _androidPlugin!.requestExactAlarmsPermission() ?? false;
    }
    return enabled;
  }

  @override
  Future<void> scheduleDailyNotification(AppNotification notification) async {
    final dateTime = _convertTime(notification.time);
    'Notification ${notification.time} at $dateTime ${dateTime.location}'.log();
    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      dateTime,
      payload: jsonEncode(notification.toMap()),
      NotificationDetails(
        android: _androidDetails(),
        iOS: _iosDetails(),
      ),
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
      groupAlertBehavior: GroupAlertBehavior.summary,
      groupKey: 'org.zp1ke.aquapact.REMINDER',
    );
  }

  DarwinNotificationDetails _iosDetails() {
    return DarwinNotificationDetails(
      threadIdentifier: 'aquapact_thread',
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
    final list = notifications
        .where((notification) => notification.payload != null)
        .map((notification) =>
            AppNotification.fromMap(jsonDecode(notification.payload!)))
        .toList(growable: false);
    list.sort((n1, n2) {
      final n1IsFuture = n1.todayTime.isAfter(DateTime.now());
      final n2IsFuture = n2.todayTime.isAfter(DateTime.now());
      if (n1IsFuture != n2IsFuture) {
        return n1IsFuture ? -1 : 1;
      }
      return n1.time.compareTo(n2.time);
    });
    return list;
  }
}
