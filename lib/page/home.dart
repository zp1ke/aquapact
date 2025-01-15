import 'package:flutter/material.dart';

import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/notification.dart';
import '../model/target_settings.dart';
import '../service/notification.dart';
import '../service/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var targetSettings = TargetSettings();
  var notifications = <AppNotification>[];

  @override
  void initState() {
    super.initState();
    readTargetSettings();
    fetchNotifications();
  }

  void readTargetSettings() {
    final settings = service<SettingsService>().readTargetSettings();
    setState(() {
      targetSettings = settings ?? TargetSettings();
    });
  }

  void fetchNotifications() async {
    final notifications =
        await service<NotificationService>().nextNotifications();
    setState(() {
      this.notifications = notifications;
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
        child: ListView(
          children: [
            Text(
                'From notification: ${service<NotificationService>().appLaunchedByNotification}'),
            Text(
                'Notif from ${targetSettings.wakeUpTime} to ${targetSettings.sleepTime}'),
            Text(
                'Notif e/ ${targetSettings.notificationInterval.inHours} hours'),
            Divider(),
            if (notifications.isNotEmpty) Text('Next notifications:'),
            ...notifications.map((notification) =>
                Text('${notification.id} - ${notification.time}')),
          ],
        ),
      ),
    );
  }
}
