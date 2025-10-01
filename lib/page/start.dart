import 'package:flutter/material.dart';

import '../app/navigation.dart';
import '../model/target_settings.dart';
import '../service/mixin/target_settings_saver.dart';
import '../service/notification.dart';
import '../service/settings.dart';
import '../ui/form/target_settings.dart';
import '../ui/icon.dart';
import '../ui/size.dart';
import '../ui/widget/ready_start.dart';
import '../ui/widget/request_permission.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TargetSettingsSaver {
  bool? hasPermission;
  TargetSettings? settings;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndSettings();
  }

  void checkPermissionsAndSettings() async {
    settings = SettingsService.get().readTargetSettings();
    final granted = await NotificationService.get().hasPermissionGranted();
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.spacingSmall,
              vertical: AppSize.spacingXL,
            ),
            child: content(context),
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    if (hasPermission == null) {
      return AppIcon.loading;
    }
    if (hasPermission == false) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingMedium),
        child: RequestPermissionWidget(
          onGranted: () {
            setState(() {
              hasPermission = true;
            });
          },
        ),
      );
    }
    if (settings == null) {
      return TargetSettingsForm(saving: saving, onSave: saveTargetSettings);
    }
    return ReadyStartWidget(
      onAction: () {
        navigateToHome(context);
      },
    );
  }

  void saveTargetSettings(TargetSettings newSettings) async {
    setState(() {
      saving = true;
    });
    await saveSettings(context, newSettings);
    setState(() {
      settings = newSettings;
    });
  }

  Future<void> navigateToHome(BuildContext context) async {
    await context.navigateTo(AppPage.home, clear: true);
  }
}
