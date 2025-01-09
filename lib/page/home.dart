import 'package:flutter/material.dart';

import '../model/target_settings.dart';

class HomePage extends StatefulWidget {
  final bool didNotificationLaunchApp;

  const HomePage({
    super.key,
    required this.didNotificationLaunchApp,
  });

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

  void readTargetSettings() async {
    final settings = await TargetSettings.read();
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
            Text('From notification: ${widget.didNotificationLaunchApp}'),
            Text(
                'Notif e/ ${targetSettings.notificationInterval.inHours} hours'),
          ],
        ),
      ),
    );
  }
}
