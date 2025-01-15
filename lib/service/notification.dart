import '../model/notification.dart';
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
      final notification = AppNotification(
        id: time.hour * 60 + time.minute,
        title: title,
        body: message,
        time: time,
      );
      await scheduleDailyNotification(notification);
      time = time.add(targetSettings.notificationInterval);
    }
  }

  Future<void> scheduleDailyNotification(AppNotification notification);

  Future<void> cancelAll();

  Future<List<AppNotification>> nextNotifications();
}
