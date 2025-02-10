import 'package:flutter/material.dart';

import '../app/di.dart';
import '../l10n/app_l10n.dart';
import '../model/target_settings.dart';
import '../service/intakes.dart';
import '../service/mixin/target_settings_saver.dart';
import '../service/settings.dart';
import '../ui/icon.dart';
import '../ui/size.dart';
import '../ui/widget/add_intake_button.dart';
import '../ui/widget/intakes_list.dart';
import '../util/date_time.dart';

class IntakesPage extends StatefulWidget {
  final DateTime? dateTime;

  const IntakesPage({
    super.key,
    this.dateTime,
  });

  @override
  State<IntakesPage> createState() => _IntakesPageState();
}

class _IntakesPageState extends State<IntakesPage> with TargetSettingsSaver {
  final intakeCtrl = IntakesController();

  var targetSettings = TargetSettings();
  late DateTime dateTime;
  var intakeValue = .0;

  @override
  void initState() {
    super.initState();
    dateTime = widget.dateTime ?? DateTime.now().atStartOfDay();
    loadData();
  }

  void loadData() {
    readTargetSettings();
    intakeCtrl.refresh(
      from: dateTime,
      to: dateTime.add(const Duration(days: 1)),
    );
    fetchIntakeValue();
  }

  void readTargetSettings() {
    final settings = service<SettingsService>().readTargetSettings();
    targetSettings = settings ?? TargetSettings();
  }

  void fetchIntakeValue() async {
    intakeValue = await service<IntakesService>().sumIntakesAmount(
        from: dateTime, to: dateTime.add(const Duration(days: 1)));
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
        child: Column(
          spacing: AppSize.spacingSmall,
          children: [
            summaryWidget(),
            Divider(),
            intakes(),
          ],
        ),
      ),
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
      subtitle: Text(
        AppL10n.of(context).intakesOf(dateTime.formatDate(context)),
      ),
      trailing: AddIntakeButton(
        targetSettings: targetSettings,
        onAdded: addedIntake,
      ),
    );
  }

  Widget intakes() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
        child: IntakesListWidget(
          controller: intakeCtrl,
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
}
