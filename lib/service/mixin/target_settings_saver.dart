import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../../model/target_settings.dart';
import '../settings.dart';

mixin TargetSettingsSaver {
  Future<void> saveSettings(
    BuildContext context,
    TargetSettings newSettings, {
    bool scheduleNotifications = true,
  }) async {
    final l10n = AppL10n.of(context);
    await SettingsService.get().saveTargetSettings(
      newSettings,
      notificationTitle: l10n.notificationTitle,
      notificationMessage: l10n.notificationMessage,
      scheduleNotifications: scheduleNotifications,
    );
  }
}
