import 'package:aquapact/model/target_settings.dart';
import 'package:aquapact/service/notification.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  test('NotificationService.scheduleNotificationsOf()', () async {
    final times = <TimeOfDay>[
      TimeOfDay(hour: 7, minute: 0),
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 10, minute: 0),
    ];
    final settings = TargetSettings(
      wakeUpTime: times.first,
      sleepTime: times.last,
      notificationIntervalInMinutes: 60,
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
  Future<void> scheduleDailyNotification(
    int id, {
    required String title,
    required String message,
    required TimeOfDay time,
  }) {
    idsTimes.add(time);
    return Future.value(null);
  }
}
