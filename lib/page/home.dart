import 'dart:io';

import 'package:flutter/material.dart';

import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/notification.dart';
import '../model/target_settings.dart';
import '../service/intakes.dart';
import '../service/mixin/target_settings_saver.dart';
import '../service/notification.dart';
import '../service/settings.dart';
import '../ui/android/app_menu.dart';
import '../ui/form/add_intake_button.dart';
import '../ui/icon.dart';
import '../ui/size.dart';
import '../ui/widget/intakes_list.dart';
import '../ui/widget/liquid_progress_indicator.dart';
import '../ui/widget/pull_refresh.dart';
import '../ui/widget/responsive.dart';
import '../util/date_time.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TargetSettingsSaver {
  final intakeCtrl = IntakesController();

  var targetSettings = TargetSettings();
  var notifications = <AppNotification>[];

  var intakeValue = .0;
  var loadingSettings = false;
  var loadingNotifications = false;
  var processing = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    readTargetSettings();
    fetchNotifications();
    final today = DateTime.now().atStartOfDay();
    intakeCtrl.refresh(
      from: today,
      to: today.add(const Duration(days: 1)),
    );
    fetchIntakeValue();
  }

  void readTargetSettings() {
    if (processing || loadingSettings) {
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
    if (processing || loadingNotifications) {
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

  void fetchIntakeValue() async {
    final today = DateTime.now().atStartOfDay();
    intakeValue = await service<IntakesService>()
        .sumIntakesAmount(from: today, to: today.add(const Duration(days: 1)));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).appTitle),
        actions: [
          reloadButton(),
        ],
      ),
      body: SafeArea(
        child: PullToRefresh(
          onRefresh: loadData,
          child: ResponsiveWidget(
            standard: (_) => standardContent(),
            medium: (_) => mediumContent(),
          ),
        ),
      ),
      drawer: menu(),
    );
  }

  Widget? menu() {
    if (Platform.isAndroid) {
      return Drawer(
        child: AppMenu(onChanged: loadData),
      );
    }
    return null;
  }

  Widget standardContent() {
    return Column(
      spacing: AppSize.spacingSmall,
      children: [
        nextNotifications(),
        addIntakeButton(),
        tipText(),
        Divider(),
        intakesToolbar(),
        lastIntakes(),
        dailyStatusText(),
        dailyStatusWidget(),
      ],
    );
  }

  Widget mediumContent() {
    return Column(
      spacing: AppSize.spacingSmall,
      children: [
        nextNotifications(),
        addIntakeButton(),
        tipText(),
        Divider(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: AppSize.spacingSmall,
                  children: [
                    intakesToolbar(),
                    lastIntakes(),
                  ],
                ),
              ),
              VerticalDivider(),
              Flexible(
                child: Column(
                  spacing: AppSize.spacingSmall,
                  children: [
                    dailyStatusText(),
                    Spacer(),
                    dailyStatusWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget reloadButton() {
    final isNotLoading = !loadingSettings && !loadingNotifications;
    return IconButton(
      icon: isNotLoading ? AppIcon.refresh : AppIcon.loading,
      onPressed: (!processing && isNotLoading) ? loadData : null,
    );
  }

  Widget addIntakeButton() {
    return AddIntakeButton(
      enabled: !processing,
      targetSettings: targetSettings,
      onAdding: () {
        setState(() {
          processing = true;
        });
      },
      onAdded: addedIntake,
    );
  }

  Widget tipText() {
    return Padding(
      padding: const EdgeInsets.all(AppSize.spacingSmall),
      child: Text(
        service<IntakesService>().tip(
          context,
          intakeValue: intakeValue,
          targetValue: targetSettings.dailyTarget,
        ),
        textScaler: TextScaler.linear(0.95),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget nextNotifications() {
    if (notifications.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            AppL10n.of(context)
                .nextNotificationAt(notifications.first.time.format(context)),
            textAlign: TextAlign.left,
            textScaler: TextScaler.linear(0.8),
          ),
        ),
      );
    }
    return Container();
  }

  Widget intakesToolbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppL10n.of(context).lastIntakes,
            textScaler: TextScaler.linear(1.2),
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          OutlinedButton(
            child: Text(AppL10n.of(context).showAll),
            onPressed: () async {
              await context.navigateTo(AppPage.intakes);
              loadData();
            },
          ),
        ],
      ),
    );
  }

  Widget lastIntakes() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
        child: IntakesListWidget(
          limit: 4,
          controller: intakeCtrl,
          dense: true,
          onChanged: fetchIntakeValue,
        ),
      ),
    );
  }

  Widget dailyStatusText() {
    final intake = targetSettings.volumeMeasureUnit
        .formatValue(intakeValue, withSymbol: false);
    final target = targetSettings.volumeMeasureUnit
        .formatValue(targetSettings.dailyTarget);
    return Text(
      '$intake / $target',
      textScaler: TextScaler.linear(1.5),
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget dailyStatusWidget() {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Center(
        child: LiquidProgressIndicatorWidget(
          value: intakeValue,
          targetValue: targetSettings.dailyTarget,
        ),
      ),
    );
  }

  void addedIntake(double value) async {
    targetSettings = targetSettings.copyWith(
      defaultIntakeValue: value,
    );
    if (mounted) {
      await saveSettings(context, targetSettings, scheduleNotifications: false);
    }
    setState(() {
      processing = false;
    });
    loadData();
  }
}
