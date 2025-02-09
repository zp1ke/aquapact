import 'package:flutter/material.dart';

import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/notification.dart';
import '../model/target_settings.dart';
import '../service/notification.dart';
import '../service/settings.dart';
import '../ui/size.dart';
import '../ui/widget/liquid_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var targetSettings = TargetSettings();
  var notifications = <AppNotification>[];

  var intakeValue = 1800.0;
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
    final size = MediaQuery.of(context).size;
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.spacingSmall),
              child: ElevatedButton.icon(
                onPressed: () {},
                label: Text('TODO'),
                icon: const Icon(Icons.add),
              ),
            ),
            Text('SOME Tip TODO'),
            Divider(),
            if (loadingNotifications)
              const CircularProgressIndicator.adaptive(),
            if (!loadingNotifications && notifications.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(right: AppSize.spacingSmall),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppL10n.of(context).nextNotificationAt(
                        notifications.first.time.format(context)),
                    textScaler: TextScaler.linear(0.8),
                  ),
                ),
              ),
            Spacer(),
            Text(
              '${intakeValue.toStringAsFixed(0)} / ${targetSettings.dailyTarget.toStringAsFixed(0)} ${targetSettings.volumeMeasureUnit.symbol}',
              textScaler: TextScaler.linear(1.5),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            SizedBox(
              width: size.width,
              height: size.height * 0.2,
              child: Center(
                child: LiquidProgressIndicatorWidget(
                  value: intakeValue,
                  targetValue: targetSettings.dailyTarget,
                ),
              ),
            ),
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
