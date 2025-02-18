import 'package:flutter/material.dart';

import '../app/config.dart';
import '../app/di.dart';
import '../l10n/app_l10n.dart';
import '../model/target_settings.dart';
import '../service/intakes.dart';
import '../service/mixin/target_settings_saver.dart';
import '../service/settings.dart';
import '../ui/form/add_intake_button.dart';
import '../ui/icon.dart';
import '../ui/size.dart';
import '../ui/widget/intakes_list.dart';
import '../ui/widget/pull_refresh.dart';
import '../util/date_time.dart';

class IntakesPage extends StatefulWidget {
  const IntakesPage({super.key});

  @override
  State<IntakesPage> createState() => _IntakesPageState();
}

class _IntakesPageState extends State<IntakesPage> with TargetSettingsSaver {
  final intakeCtrl = IntakesController();

  var targetSettings = TargetSettings();
  var dateTime = DateTime.now().atStartOfDay();
  var intakeValue = .0;

  DateTime get toDateTime => dateTime.add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    readTargetSettings();
    intakeCtrl.refresh(
      from: dateTime,
      to: toDateTime,
    );
    fetchIntakeValue();
  }

  void readTargetSettings() {
    final settings = service<SettingsService>().readTargetSettings();
    targetSettings = settings ?? TargetSettings();
  }

  void fetchIntakeValue() async {
    intakeValue = await service<IntakesService>()
        .sumIntakesAmount(from: dateTime, to: toDateTime);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).intakes),
        actions: [
          reloadButton(),
        ],
      ),
      body: SafeArea(
        child: PullToRefresh(
          onRefresh: loadData,
          child: content(),
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      spacing: AppSize.spacingSmall,
      children: [
        summaryWidget(),
        Divider(height: .0),
        intakes(),
      ],
    );
  }

  Widget reloadButton() {
    return IconButton(
      icon: AppIcon.refresh,
      onPressed: loadData,
    );
  }

  Widget summaryWidget() {
    return ListTile(
      title: Text(
        AppL10n.of(context).totalIntake(
          targetSettings.volumeMeasureUnit.formatValue(intakeValue),
        ),
      ),
      subtitle: dateButton(),
      trailing: AddIntakeButton(
        enabled: dateTime.isToday,
        targetSettings: targetSettings,
        onAdded: addedIntake,
      ),
    );
  }

  Widget dateButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: pickDate,
          child: Text(
            AppL10n.of(context).intakesOf(dateTime.formatDate(context)),
          ),
        ),
      ],
    );
  }

  Widget intakes() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
        child: IntakesListWidget(
          controller: intakeCtrl,
          onChanged: fetchIntakeValue,
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
    loadData();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: AppConfig.launchDateTime,
      initialDate: dateTime,
      lastDate: now,
    );
    if (date != null) {
      setState(() {
        dateTime = date.atStartOfDay();
        loadData();
      });
    }
  }
}
