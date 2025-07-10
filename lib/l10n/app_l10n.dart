import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_en.dart';
import 'app_l10n_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AquaPact'**
  String get appTitle;

  /// No description provided for @allowAppNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow App Notifications'**
  String get allowAppNotifications;

  /// No description provided for @allowAppNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'We will need permission so the app can send you notifications.'**
  String get allowAppNotificationsDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @customIntake.
  ///
  /// In en, this message translates to:
  /// **'Custom...'**
  String get customIntake;

  /// No description provided for @dailyWaterIntake.
  ///
  /// In en, this message translates to:
  /// **'Daily Water Intake'**
  String get dailyWaterIntake;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @enterCustomIntake.
  ///
  /// In en, this message translates to:
  /// **'Enter custom Intake...'**
  String get enterCustomIntake;

  /// No description provided for @enterIntakeValue.
  ///
  /// In en, this message translates to:
  /// **'Enter Intake Value'**
  String get enterIntakeValue;

  /// No description provided for @healthSync.
  ///
  /// In en, this message translates to:
  /// **'Sync with Health Apps'**
  String get healthSync;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @intakeAverage.
  ///
  /// In en, this message translates to:
  /// **'{amount} average'**
  String intakeAverage(String amount);

  /// No description provided for @intakes.
  ///
  /// In en, this message translates to:
  /// **'Intakes'**
  String get intakes;

  /// No description provided for @intakeIn.
  ///
  /// In en, this message translates to:
  /// **'Intake amount ({unit})'**
  String intakeIn(String unit);

  /// No description provided for @intakeMessageOf.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached {percent}% of your hydration goal. Keep it going and stay refreshed! 💧💪'**
  String intakeMessageOf(String percent);

  /// No description provided for @intakeMessageMorning0.
  ///
  /// In en, this message translates to:
  /// **'Good morning! 🌞 Start your day right with a refreshing glass of water! 💧 Let\'s begin our journey to staying hydrated today!'**
  String get intakeMessageMorning0;

  /// No description provided for @intakeMessageMidday25.
  ///
  /// In en, this message translates to:
  /// **'Great start! You\'ve reached 25% of your hydration goal. Keep it going and stay refreshed! 💧💪'**
  String get intakeMessageMidday25;

  /// No description provided for @intakeMessageMidday50.
  ///
  /// In en, this message translates to:
  /// **'You\'re halfway there! 50% of your goal is complete. Keep sipping and stay on track! 💦👏'**
  String get intakeMessageMidday50;

  /// No description provided for @intakeMessageAfternoon75.
  ///
  /// In en, this message translates to:
  /// **'Fantastic progress! You\'re at 75% of your hydration goal. Just a little more to go! 💧🚀'**
  String get intakeMessageAfternoon75;

  /// No description provided for @intakeMessageEvening90.
  ///
  /// In en, this message translates to:
  /// **'Almost there! You\'re at 90% of your goal. Just a little more effort and you\'ll make it! 💦✨'**
  String get intakeMessageEvening90;

  /// No description provided for @intakeMessage10.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry, you still have time to catch up! Drink a cup of water now and stay on track to reach your goal. 💧🌟'**
  String get intakeMessage10;

  /// No description provided for @intakeMessage30.
  ///
  /// In en, this message translates to:
  /// **'You can do it! Take a moment to drink a glass of water and keep pushing towards your goal. 💦💪'**
  String get intakeMessage30;

  /// No description provided for @intakeMessage100.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve achieved 100% of your hydration goal today. Great job staying hydrated! 💧🥳'**
  String get intakeMessage100;

  /// No description provided for @intakesOf.
  ///
  /// In en, this message translates to:
  /// **'Intakes of {date}'**
  String intakesOf(String date);

  /// No description provided for @intakeRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Intake record deleted'**
  String get intakeRecordDeleted;

  /// No description provided for @intakeValues.
  ///
  /// In en, this message translates to:
  /// **'Intake Values'**
  String get intakeValues;

  /// No description provided for @lastNDays.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days (and today)'**
  String lastNDays(String days);

  /// No description provided for @lastIntakes.
  ///
  /// In en, this message translates to:
  /// **'Last Intakes'**
  String get lastIntakes;

  /// No description provided for @lastTip.
  ///
  /// In en, this message translates to:
  /// **'Press the item to finish'**
  String get lastTip;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'let\'s Start!'**
  String get letsStart;

  /// No description provided for @nextNotificationAt.
  ///
  /// In en, this message translates to:
  /// **'Next Notification at {time}'**
  String nextNotificationAt(String time);

  /// No description provided for @nextTip.
  ///
  /// In en, this message translates to:
  /// **'Press the item to see the next tip'**
  String get nextTip;

  /// No description provided for @noIntakesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No intakes recorded :('**
  String get noIntakesRecorded;

  /// No description provided for @noIntakesYet.
  ///
  /// In en, this message translates to:
  /// **'No intakes yet. Drink some water to get started.'**
  String get noIntakesYet;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Drink Water Reminder'**
  String get notificationTitle;

  /// No description provided for @notificationMessage.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to drink water!'**
  String get notificationMessage;

  /// No description provided for @notifyEveryHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Notify hourly} other{Notify every {count} hours}}'**
  String notifyEveryHours(num count);

  /// No description provided for @preserveValue.
  ///
  /// In en, this message translates to:
  /// **'Preserve Value'**
  String get preserveValue;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @sureLetsDoIt.
  ///
  /// In en, this message translates to:
  /// **'Sure, let\'s do it'**
  String get sureLetsDoIt;

  /// No description provided for @targetSettings.
  ///
  /// In en, this message translates to:
  /// **'Target Settings'**
  String get targetSettings;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today at {time}'**
  String todayAt(String time);

  /// No description provided for @totalIntake.
  ///
  /// In en, this message translates to:
  /// **'Total Intake: {amount}'**
  String totalIntake(String amount);

  /// No description provided for @tutorialAddIntake.
  ///
  /// In en, this message translates to:
  /// **'Press this button to add an intake. Long press to show more intake options.'**
  String get tutorialAddIntake;

  /// No description provided for @tutorialIntakeAmount.
  ///
  /// In en, this message translates to:
  /// **'This shows the amount of water you have consumed.'**
  String get tutorialIntakeAmount;

  /// No description provided for @tutorialNextNotification.
  ///
  /// In en, this message translates to:
  /// **'Here you can see when the next notification will be sent. You can change the frequency in the settings.'**
  String get tutorialNextNotification;

  /// No description provided for @tutorialShowAll.
  ///
  /// In en, this message translates to:
  /// **'Here you can navigate to the list of all intakes, where you can edit and delete.'**
  String get tutorialShowAll;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @wakeUpSleepTimes.
  ///
  /// In en, this message translates to:
  /// **'Wake Up at {wakeUpTime}, Sleep at {sleepTime}'**
  String wakeUpSleepTimes(String wakeUpTime, String sleepTime);

  /// No description provided for @wakeUp.
  ///
  /// In en, this message translates to:
  /// **'Wake Up'**
  String get wakeUp;

  /// No description provided for @weAreGoodToGo.
  ///
  /// In en, this message translates to:
  /// **'We are good to go'**
  String get weAreGoodToGo;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'es':
      return AppL10nEs();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
