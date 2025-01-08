import 'package:flutter/material.dart';

import '../app/navigation.dart';
import '../app/notification.dart';
import '../model/target_settings.dart';
import '../ui/form/target_settings.dart';
import '../ui/size.dart';
import '../ui/widget/ready_start.dart';
import '../ui/widget/request_permission.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool? hasPermission;
  TargetSettings? settings;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndSettings();
  }

  void checkPermissionsAndSettings() async {
    settings = await TargetSettings.read();
    final granted = await AppNotification.I.hasPermissionGranted();
    if (mounted && granted && settings != null) {
      await navigateToHome(context);
    }
    setState(() {
      hasPermission = granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.spacingSmall,
            vertical: AppSize.spacing4Xl,
          ),
          child: content(context),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    if (hasPermission == null) {
      return CircularProgressIndicator.adaptive();
    }
    if (hasPermission == false) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingMedium),
        child: RequestPermissionWidget(onGranted: () {
          setState(() {
            hasPermission = true;
          });
        }),
      );
    }
    if (settings == null) {
      return TargetSettingsForm(onSave: (newSettings) async {
        await newSettings.save();
        setState(() {
          settings = newSettings;
        });
      });
    }
    return ReadyStartWidget(onAction: () {
      navigateToHome(context);
    });
  }

  Future<void> navigateToHome(BuildContext context) async {
    await context.navigateTo(AppPage.home, clear: true);
  }
}
