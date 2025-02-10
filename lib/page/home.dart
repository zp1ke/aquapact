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
import '../ui/size.dart';
import '../ui/widget/intakes_list.dart';
import '../ui/widget/liquid_progress_indicator.dart';
import '../ui/widget/popup_button.dart';
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
    intakeCtrl.refresh();
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
          statsButton(),
          settingsButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
          spacing: AppSize.spacingSmall,
          children: [
            addIntakeButton(),
            tipText(),
            Divider(),
            nextNotifications(),
            intakesToolbar(),
            lastIntakes(),
            dailyStatusText(),
            dailyStatusWidget(),
          ],
        ),
      ),
    );
  }

  Widget settingsButton() {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: !processing
          ? () async {
              await context.navigateTo<TargetSettings?>(AppPage.targetSettings);
              loadData();
            }
          : null,
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
      onPressed: (!processing && isNotLoading) ? loadData : null,
    );
  }

  Widget statsButton() {
    final isNotLoading =
        !processing && !loadingSettings && !loadingNotifications;
    return IconButton(
      icon: const Icon(Icons.area_chart),
      onPressed: isNotLoading ? () {} : null,
    );
  }

  Widget addIntakeButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.spacingSmall),
      child: PopupButton<double>(
        enabled: !processing,
        value: targetSettings.defaultIntakeValue,
        values: targetSettings.intakeValues,
        icon: const Icon(Icons.add),
        onSelected: addIntake,
        itemBuilder: intakeWidget,
      ),
    );
  }

  Widget intakeWidget(double value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSize.spacingSmall,
      children: [
        Icon(Icons.local_drink),
        Text(
          '$value ${targetSettings.volumeMeasureUnit.symbol}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget tipText() {
    return Text(
      'SOME Tip TODO',
      style: TextStyle(
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget nextNotifications() {
    if (notifications.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(right: AppSize.spacingSmall),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            AppL10n.of(context)
                .nextNotificationAt(notifications.first.time.format(context)),
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
          TextButton(
            child: Text(AppL10n.of(context).showAll),
            onPressed: () {
              // context.navigateTo(AppPage.intakes)
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
        ),
      ),
    );
  }

  Widget dailyStatusText() {
    return Text(
      '${intakeValue.toStringAsFixed(0)} / ${targetSettings.dailyTarget.toStringAsFixed(0)} ${targetSettings.volumeMeasureUnit.symbol}',
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

  void addIntake(double value) async {
    setState(() {
      processing = true;
    });
    await service<IntakesService>().addIntake(
      amount: value,
      measureUnit: targetSettings.volumeMeasureUnit,
    );
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
