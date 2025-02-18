// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get appTitle => 'AquaPact';

  @override
  String get allowAppNotifications => 'Allow App Notifications';

  @override
  String get allowAppNotificationsDescription =>
      'We will need permission so the app can send you notifications.';

  @override
  String get cancel => 'Cancel';

  @override
  String get dailyWaterIntake => 'Daily Water Intake';

  @override
  String get edit => 'Edit';

  @override
  String intakeAverage(String amount) {
    return '$amount average';
  }

  @override
  String get intakes => 'Intakes';

  @override
  String intakeMessageOf(String percent) {
    return 'You\'ve reached $percent% of your hydration goal. Keep it going and stay refreshed! 💧💪';
  }

  @override
  String get intakeMessageMorning0 =>
      'Good morning! 🌞 Start your day right with a refreshing glass of water! 💧 Let\'s begin our journey to staying hydrated today!';

  @override
  String get intakeMessageMidday25 =>
      'Great start! You\'ve reached 25% of your hydration goal. Keep it going and stay refreshed! 💧💪';

  @override
  String get intakeMessageMidday50 =>
      'You\'re halfway there! 50% of your goal is complete. Keep sipping and stay on track! 💦👏';

  @override
  String get intakeMessageAfternoon75 =>
      'Fantastic progress! You\'re at 75% of your hydration goal. Just a little more to go! 💧🚀';

  @override
  String get intakeMessageEvening90 =>
      'Almost there! You\'re at 90% of your goal. Just a little more effort and you\'ll make it! 💦✨';

  @override
  String get intakeMessage10 =>
      'Don\'t worry, you still have time to catch up! Drink a cup of water now and stay on track to reach your goal. 💧🌟';

  @override
  String get intakeMessage30 =>
      'You can do it! Take a moment to drink a glass of water and keep pushing towards your goal. 💦💪';

  @override
  String get intakeMessage100 =>
      'Congratulations! You\'ve achieved 100% of your hydration goal today. Great job staying hydrated! 💧🥳';

  @override
  String intakesOf(String date) {
    return 'Intakes of $date';
  }

  @override
  String get intakeRecordDeleted => 'Intake record deleted';

  @override
  String lastNDays(String days) {
    return 'Last $days days';
  }

  @override
  String get lastIntakes => 'Last Intakes';

  @override
  String get letsStart => 'let\'s Start!';

  @override
  String nextNotificationAt(String time) {
    return 'Next Notification at $time';
  }

  @override
  String get noIntakesRecorded => 'No intakes recorded :(';

  @override
  String get noIntakesYet => 'No intakes yet. Drink some water to get started.';

  @override
  String get notificationTitle => 'Drink Water Reminder';

  @override
  String get notificationMessage => 'It\'s time to drink water!';

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
  String get saving => 'Saving...';

  @override
  String get settings => 'Settings';

  @override
  String get showAll => 'Show All';

  @override
  String get sleep => 'Sleep';

  @override
  String get stats => 'Stats';

  @override
  String get sureLetsDoIt => 'Sure, let\'s do it';

  @override
  String get targetSettings => 'Target Settings';

  @override
  String get today => 'Today';

  @override
  String todayAt(String time) {
    return 'Today at $time';
  }

  @override
  String totalIntake(String amount) {
    return 'Total Intake: $amount';
  }

  @override
  String get undo => 'Undo';

  @override
  String get version => 'Version';

  @override
  String wakeUpSleepTimes(String wakeUpTime, String sleepTime) {
    return 'Wake Up at $wakeUpTime, Sleep at $sleepTime';
  }

  @override
  String get wakeUp => 'Wake Up';

  @override
  String get weAreGoodToGo => 'We are good to go';
}
