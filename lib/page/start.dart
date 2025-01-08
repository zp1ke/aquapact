import 'package:flutter/material.dart';

import '../app/navigation.dart';
import '../app/notification.dart';
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
  bool hasSettings = false;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndSettings();
  }

  void checkPermissionsAndSettings() async {
    hasSettings = false; // TODO: check from settings
    final granted = await AppNotification.I.hasPermissionGranted();
    if (mounted && granted && hasSettings) {
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
          padding: AppSize.padding2_4Xl,
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
      return RequestPermissionWidget(onGranted: () {
        setState(() {
          hasPermission = true;
        });
      });
    }
    if (!hasSettings) {
      return TargetSettingsForm();
    }
    return ReadyStartWidget(onAction: () {
      navigateToHome(context);
    });
  }

  Future<void> navigateToHome(BuildContext context) async {
    await context.navigateTo(AppPage.home);
  }
}
