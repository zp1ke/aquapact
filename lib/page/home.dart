import 'package:flutter/material.dart';

import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/target_settings.dart';
import '../service/notification.dart';
import '../service/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TargetSettings targetSettings = TargetSettings();

  @override
  void initState() {
    super.initState();
    readTargetSettings();
  }

  void readTargetSettings() {
    final settings = service<SettingsService>().readTargetSettings();
    setState(() {
      targetSettings = settings ?? TargetSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final settings = await context
                  .navigateTo<TargetSettings?>(AppPage.targetSettings);
              if (settings != null) {
                setState(() {
                  targetSettings = settings;
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
                'From notification: ${service<NotificationService>().appLaunchedByNotification}'),
            Text(
                'Notif from ${targetSettings.wakeUpTime} to ${targetSettings.sleepTime}'),
            Text(
                'Notif e/ ${targetSettings.notificationInterval.inHours} hours'),
          ],
        ),
      ),
    );
  }
}
