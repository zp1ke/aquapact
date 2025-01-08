import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static AppSettings? _instance;

  static Future<AppSettings> get I async {
    if (_instance == null) {
      final plugin = await SharedPreferences.getInstance();
      _instance = AppSettings._(plugin);
    }
    return _instance!;
  }

  final SharedPreferences plugin;

  AppSettings._(this.plugin);

  T? read<T>(String key) {
    if (T == String) {
      return plugin.getString(key) as T?;
    }
    if (T == Map<String, dynamic>) {
      final json = plugin.getString(key);
      if (json != null) {
        return jsonDecode(json) as T?;
      }
    }
    return null;
  }

  Future<bool> write<T>(String key, T value) async {
    if (value is String) {
      return plugin.setString(key, value);
    }
    if (value is Map<String, dynamic>) {
      final json = jsonEncode(value);
      return plugin.setString(key, json);
    }
    return Future.value(false);
  }
}
