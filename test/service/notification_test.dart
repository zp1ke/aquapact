import 'package:aquapact/model/notification.dart';
import 'package:aquapact/model/target_settings.dart';
import 'package:aquapact/service/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NotificationService.scheduleNotificationsOf()', () async {
    final times = <TimeOfDay>[
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 12, minute: 0),
      TimeOfDay(hour: 14, minute: 0),
      TimeOfDay(hour: 16, minute: 0),
      TimeOfDay(hour: 18, minute: 0),
      TimeOfDay(hour: 20, minute: 0),
      TimeOfDay(hour: 22, minute: 0),
    ];
    final settings = TargetSettings(
      wakeUpTime: times.first,
      sleepTime: times.last,
      notificationIntervalInMinutes: 120,
    );
    final title = 'title';
    final message = 'message';

    final service = FakeNotificationService();

    await service.scheduleNotificationsOf(
      settings,
      title: title,
      message: message,
    );
    expect(service.cancelledCount, equals(1));
    expect(service.idsTimes.length, equals(times.length));
    for (var i = 0; i < times.length; i++) {
      expect(service.idsTimes[i], equals(times[i]));
    }
  });
}

class FakeNotificationService extends NotificationService {
  final idsTimes = <TimeOfDay>[];
  int cancelledCount = 0;

  @override
  bool get appLaunchedByNotification => false;

  @override
  Future<void> cancelAll() {
    cancelledCount += 1;
    return Future.value(null);
  }

  @override
  Future<bool> hasPermissionGranted() {
    return Future.value(true);
  }

  @override
  Future<void> scheduleDailyNotification(AppNotification notification) {
    idsTimes.add(notification.time);
    return Future.value(null);
  }

  @override
  Future<List<AppNotification>> nextNotifications() {
    return Future.value([]);
  }
}
