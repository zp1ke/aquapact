import 'package:flutter/material.dart';

import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/target_settings.dart';
import '../service/notification.dart';
import '../service/settings.dart';
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
  bool saving = false;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndSettings();
  }

  void checkPermissionsAndSettings() async {
    settings = service<SettingsService>().readTargetSettings();
    final granted = await service<NotificationService>().hasPermissionGranted();
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
              vertical: AppSize.spacing4Xl,
            ),
            child: content(context),
          ),
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
      return TargetSettingsForm(
        saving: saving,
        onSave: (newSettings) {
          saveTargetSettings(context, newSettings);
        },
      );
    }
    return ReadyStartWidget(onAction: () {
      navigateToHome(context);
    });
  }

  void saveTargetSettings(
    BuildContext context,
    TargetSettings newSettings,
  ) async {
    setState(() {
      saving = true;
    });
    final l10n = AppL10n.of(context);
    await service<SettingsService>().saveTargetSettings(
      newSettings,
      notificationTitle: l10n.notificationTitle,
      notificationMessage: l10n.notificationMessage,
    );
    setState(() {
      settings = newSettings;
    });
  }

  Future<void> navigateToHome(BuildContext context) async {
    await context.navigateTo(
      AppPage.home,
      clear: true,
    );
  }
}
