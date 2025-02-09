import 'package:flutter/material.dart';

import '../../app/di.dart';
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
    await service<SettingsService>().saveTargetSettings(
      newSettings,
      notificationTitle: l10n.notificationTitle,
      notificationMessage: l10n.notificationMessage,
      scheduleNotifications: scheduleNotifications,
    );
  }
}
