import 'package:flutter/material.dart';

import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/notification.dart';
import '../model/target_settings.dart';
import '../service/notification.dart';
import '../service/settings.dart';
import '../ui/size.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var targetSettings = TargetSettings();
  var notifications = <AppNotification>[];

  var loadingSettings = false;
  var loadingNotifications = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    readTargetSettings();
    fetchNotifications();
  }

  void readTargetSettings() {
    if (loadingSettings) {
      return;
    }
    setState(() {
      loadingSettings = true;
    });
    final settings = service<SettingsService>().readTargetSettings();
    setState(() {
      targetSettings = settings ?? TargetSettings();
      loadingSettings = false;
    });
  }

  void fetchNotifications() async {
    if (loadingNotifications) {
      return;
    }
    setState(() {
      loadingNotifications = true;
    });
    final notifications =
        await service<NotificationService>().nextNotifications();
    setState(() {
      this.notifications = notifications;
      loadingNotifications = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).appTitle),
        actions: [
          reloadButton(),
          settingsButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
          spacing: AppSize.spacingSmall,
          children: [
            Text(
                'From notification: ${service<NotificationService>().appLaunchedByNotification}'),
            if (loadingSettings) const CircularProgressIndicator.adaptive(),
            if (!loadingSettings)
              Text(
                  'Notif from ${targetSettings.wakeUpTime} to ${targetSettings.sleepTime}'),
            if (!loadingSettings)
              Text(
                  'Notif e/ ${targetSettings.notificationInterval.inHours} hours'),
            Divider(),
            if (loadingNotifications)
              const CircularProgressIndicator.adaptive(),
            if (!loadingNotifications && notifications.isNotEmpty)
              Text('Next notifications:'),
            if (!loadingNotifications)
              ...notifications.map((notification) =>
                  Text('${notification.id} - ${notification.time}')),
          ],
        ),
      ),
    );
  }

  Widget settingsButton() {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        await context.navigateTo<TargetSettings?>(AppPage.targetSettings);
        loadData();
      },
    );
  }

  Widget reloadButton() {
    final isNotLoading = !loadingSettings && !loadingNotifications;
    return IconButton(
      icon: isNotLoading
          ? const Icon(Icons.refresh)
          : const SizedBox(
              width: AppSize.spacingXS,
              height: AppSize.spacingXS,
              child: CircularProgressIndicator.adaptive(),
            ),
      onPressed: isNotLoading ? loadData : null,
    );
  }
}
