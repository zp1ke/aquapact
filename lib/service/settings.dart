import '../app/di.dart';
import '../model/target_settings.dart';

abstract class SettingsService {
  static SettingsService get() => service<SettingsService>();

  TargetSettings? readTargetSettings();

  bool homeWizardCompleted();

  Future<bool> saveTargetSettings(
    TargetSettings targetSettings, {
    required String notificationTitle,
    required String notificationMessage,
    required bool scheduleNotifications,
  });

  Future<bool> saveHomeWizardCompleted();
}
