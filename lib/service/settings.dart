import '../model/target_settings.dart';

abstract class SettingsService {
  TargetSettings? readTargetSettings();

  Future<bool> saveTargetSettings(
    TargetSettings targetSettings, {
    required String notificationTitle,
    required String notificationMessage,
    required bool scheduleNotifications,
  });
}
