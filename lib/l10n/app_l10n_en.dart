import 'package:intl/intl.dart' as intl;

import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AquaPact';

  @override
  String get allowAppNotifications => 'Allow App Notifications';

  @override
  String get allowAppNotificationsDescription => 'We will need permission so the app can send you notifications.';

  @override
  String get dailyWaterIntake => 'Daily Water Intake';

  @override
  String get edit => 'Edit';

  @override
  String get letsStart => 'let\'s Start!';

  @override
  String notifyEveryHours(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notify every $count hours',
      one: 'Notify hourly',
    );
    return '$_temp0';
  }

  @override
  String get save => 'Save';

  @override
  String get sleep => 'Sleep';

  @override
  String get sureLetsDoIt => 'Sure, let\'s do it';

  @override
  String wakeUpSleepTimes(String wakeUpTime, String sleepTime) {
    return 'Wake Up at $wakeUpTime, Sleep at $sleepTime';
  }

  @override
  String get wakeUp => 'Wake Up';

  @override
  String get weAreGoodToGo => 'We are good to go';
}
