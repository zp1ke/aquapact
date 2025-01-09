import '../model/target_settings.dart';

abstract class NotificationService {
  /// returns true if the app was launched by a notification.
  bool get appLaunchedByNotification;

  Future<bool> hasPermissionGranted();

  Future<bool> requestPermissions();

  Future<void> scheduleNotificationsOf(
    TargetSettings targetSettings, {
    required String title,
    required String message,
  });
}
