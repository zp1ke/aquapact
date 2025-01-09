import 'package:flutter/material.dart';

import '../l10n/app_l10n.dart';
import '../page/start.dart';
import '../ui/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

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
