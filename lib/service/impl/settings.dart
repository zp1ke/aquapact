import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/target_settings.dart';
import '../notification.dart';
import '../settings.dart';

const _targetSettingsKey = 'target_settings';
const _homeWizardKey = 'home_wizard';

class LocalSettingsService implements SettingsService {
  final SharedPreferences _plugin;

  LocalSettingsService._(this._plugin);

  static Future<SettingsService> create() async {
    final plugin = await SharedPreferences.getInstance();
    return LocalSettingsService._(plugin);
  }

  @override
  TargetSettings? readTargetSettings() {
    final Map<String, dynamic>? map = _read(_targetSettingsKey);
    if (map != null) {
      return TargetSettings.fromMap(map);
    }
    return null;
  }

  @override
  Future<bool> saveTargetSettings(
    TargetSettings targetSettings, {
    required String notificationTitle,
    required String notificationMessage,
    required bool scheduleNotifications,
  }) async {
    if (scheduleNotifications) {
      await NotificationService.get().scheduleNotificationsOf(
        targetSettings,
        title: notificationTitle,
        message: notificationMessage,
      );
    }
    return _write(_targetSettingsKey, targetSettings.toMap());
  }

  T? _read<T>(String key) {
    if (T == String) {
      return _plugin.getString(key) as T?;
    }
    if (T == Map<String, dynamic>) {
      final json = _plugin.getString(key);
      if (json != null) {
        return jsonDecode(json) as T?;
      }
    }
    return null;
  }

  Future<bool> _write<T>(String key, T value) async {
    if (value is String) {
      return _plugin.setString(key, value);
    }
    if (value is Map<String, dynamic>) {
      final json = jsonEncode(value);
      return _plugin.setString(key, json);
    }
    return Future.value(false);
  }

  @override
  bool homeWizardCompleted() {
    return _plugin.getBool(_homeWizardKey) ?? false;
  }

  @override
  Future<bool> saveHomeWizardCompleted() {
    return _plugin.setBool(_homeWizardKey, true);
  }
}
