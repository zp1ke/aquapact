import 'package:flutter/material.dart';

import '../model/target_settings.dart';

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

  void readTargetSettings() async {
    final settings = await TargetSettings.read();
    setState(() {
      targetSettings = settings ?? TargetSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'Home Page TODO, notify every ${targetSettings.notificationInterval.inHours} hours'),
      ),
    );
  }
}
