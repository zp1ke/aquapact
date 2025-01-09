import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/notification.dart';
import 'l10n/app_l10n.dart';
import 'page/start.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  final didNotificationLaunchApp = await AppNotification.I.initialize();

  runApp(MyApp(
    didNotificationLaunchApp: didNotificationLaunchApp,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.didNotificationLaunchApp,
  });

  final bool didNotificationLaunchApp;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(context);
    return MaterialApp(
      onGenerateTitle: (context) => AppL10n.of(context).appTitle,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      themeMode: ThemeMode.system,
      theme: theme.lightMediumContrast(),
      darkTheme: theme.darkMediumContrast(),
      home: StartPage(),
    );
  }
}
