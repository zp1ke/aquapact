import 'package:flutter/material.dart';

import '../app/di.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Text(
                'From notification: ${service<NotificationService>().appLaunchedByNotification}'),
            Text(
                'Notif e/ ${targetSettings.notificationInterval.inHours} hours'),
          ],
        ),
      ),
    );
  }
}
