import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../l10n/app_l10n.dart';
import '../../model/target_settings.dart';
import '../../service/health.dart';
import '../../util/number.dart';
import '../color.dart';
import '../icon.dart';
import '../size.dart';
import '../widget/custom_intake.dart';
import '../widget/responsive.dart';
import 'slider.dart';

class TargetSettingsForm extends StatefulWidget {
  final TargetSettings? targetSettings;
  final bool saving;
  final Function(TargetSettings) onSave;
  final VoidCallback? onCancel;

  const TargetSettingsForm({
    super.key,
    this.targetSettings,
    this.saving = false,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<TargetSettingsForm> createState() => _TargetSettingsFormState();
}

class _TargetSettingsFormState extends State<TargetSettingsForm> {
  var targetSettings = TargetSettings();

  @override
  void initState() {
    super.initState();
    if (widget.targetSettings != null) {
      targetSettings = widget.targetSettings!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveWidget(
        standard: (_) => standardContent(),
        medium: (_) => mediumContent(),
      ),
    );
  }

  Widget standardContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.spacingMedium),
      child: Column(
        spacing: AppSize.spacingMedium,
        children: [
          card(dailyTargetCard()),
          card(wakeUpSleepTimesCard()),
          card(notificationIntervalCard()),
          card(intakeValues()),
          card(healthSync()),
          SizedBox(height: AppSize.spacingLarge),
          toolbar(),
        ],
      ),
    );
  }

  Widget mediumContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.spacingMedium),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: AppSize.spacingMedium,
              mainAxisSpacing: AppSize.spacingMedium,
              childAspectRatio: 10 / 4,
              children: [
                card(dailyTargetCard()),
                card(wakeUpSleepTimesCard()),
                card(notificationIntervalCard()),
                card(intakeValues()),
                card(healthSync()),
              ],
            ),
          ),
          toolbar(),
        ],
      ),
    );
  }

  Widget card(Widget child) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSize.spacingLarge),
        child: Center(child: child),
      ),
    );
  }

  Widget dailyTargetCard() {
    final measureUnit = targetSettings.volumeMeasureUnit;
    final theme = Theme.of(context);
    return Column(
      spacing: AppSize.spacingLarge,
      children: [
        cardTitle(
            '${AppL10n.of(context).dailyWaterIntake} (${measureUnit.symbol})'),
        SliderWidget(
          value: targetSettings.dailyTarget,
          min: 500.0,
          max: 5000.0,
          enabled: !widget.saving,
          interval: 1000.0,
          fromColor: theme.colorScheme.deepWater,
          toColor: theme.colorScheme.water,
          textColor: Colors.white,
          valueFormatter: (value) =>
              measureUnit.formatValue(value, withSymbol: false),
          onChanged: (value) {
            setState(() {
              targetSettings = targetSettings.copyWith(
                dailyTarget: value.roundToNearestHundred(),
              );
            });
          },
        ),
      ],
    );
  }

  Widget wakeUpSleepTimesCard() {
    final l10n = AppL10n.of(context);
    return Column(
      spacing: AppSize.spacingMedium,
      children: [
        cardTitle(l10n.wakeUpSleepTimes(
          targetSettings.wakeUpTime.format(context),
          targetSettings.sleepTime.format(context),
        )),
        OutlinedButton(
          onPressed: !widget.saving ? editWakeUpSleepTimes : null,
          child: Text(l10n.edit),
        ),
      ],
    );
  }

  void editWakeUpSleepTimes() async {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);
    final TimeRange? result = await showTimeRangePicker(
      context: context,
      start: targetSettings.wakeUpTime,
      end: targetSettings.sleepTime,
      interval: Duration(minutes: 30),
      fromText: l10n.wakeUp,
      toText: l10n.sleep,
      disabledTime: TimeRange(
        startTime: const TimeOfDay(hour: 23, minute: 30),
        endTime: const TimeOfDay(hour: 4, minute: 0),
      ),
      disabledColor: theme.disabledColor,
      strokeWidth: AppSize.spacingSmall,
      use24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      ticks: 24,
      ticksOffset: -7,
      ticksLength: 5,
      ticksColor: theme.colorScheme.secondary,
      labelOffset: AppSize.spacingLarge * 1.5,
      rotateLabels: false,
      padding: AppSize.spacingLarge,
    );
    if (result != null) {
      setState(() {
        targetSettings = targetSettings.copyWith(
          wakeUpTime: result.startTime,
          sleepTime: result.endTime,
        );
      });
    }
  }

  Widget notificationIntervalCard() {
    return Column(
      spacing: AppSize.spacingLarge,
      children: [
        cardTitle(AppL10n.of(context)
            .notifyEveryHours(targetSettings.notificationInterval.inHours)),
        SliderWidget(
          value: targetSettings.notificationInterval.inHours.toDouble(),
          min: 1.0,
          max: 4.0,
          enabled: !widget.saving,
          interval: 1.0,
          valueFormatter: (value) => value.toInt().toString(),
          onChanged: (value) {
            setState(() {
              targetSettings = targetSettings.copyWith(
                notificationIntervalInMinutes: value.toInt() * 60,
              );
            });
          },
        ),
      ],
    );
  }

  Widget intakeValues() {
    return Column(
      spacing: AppSize.spacingMedium,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardTitle(AppL10n.of(context).intakeValues),
            IconButton(
              onPressed: !widget.saving ? addCustomIntake : null,
              icon: AppIcon.add,
            ),
          ],
        ),
        Wrap(
          spacing: AppSize.spacingSmall,
          runSpacing: AppSize.spacingSmall,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: targetSettings.intakeValues
              .map(
                (value) => Chip(
                  label: Text(value.toInt().toString()),
                  deleteIcon: AppIcon.delete(context),
                  onDeleted: targetSettings.intakeValues.length > 1
                      ? () => deleteIntake(value)
                      : null,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget healthSync() {
    return Row(
      spacing: AppSize.spacingLarge,
      children: [
        cardTitle(AppL10n.of(context).healthSync),
        Switch(
          value: targetSettings.healthSync,
          onChanged: (value) async {
            var theValue = value;
            if (value) {
              theValue = await HealthService.get().hasPermissionGranted();
            }
            setState(() {
              targetSettings = targetSettings.copyWith(
                healthSync: theValue,
              );
            });
          },
        ),
      ],
    );
  }

  Widget toolbar() {
    final saveBtn = saveButton();
    if (widget.onCancel == null) {
      return saveBtn;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: !widget.saving ? widget.onCancel : null,
          child: Text(AppL10n.of(context).cancel),
        ),
        saveBtn,
      ],
    );
  }

  Widget cardTitle(String text) {
    return Text(
      text,
      style: TextTheme.of(context).bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget saveButton() {
    return OutlinedButton.icon(
      onPressed: !widget.saving
          ? () {
              widget.onSave(targetSettings);
            }
          : null,
      icon: widget.saving ? AppIcon.loading : null,
      label: Text(widget.saving
          ? AppL10n.of(context).saving
          : AppL10n.of(context).save),
    );
  }

  void addCustomIntake() async {
    final value = await getCustomIntake(
      context,
      title: AppL10n.of(context).enterIntakeValue,
      targetSettings: targetSettings,
    );
    if (value != null) {
      setState(() {
        targetSettings = value.first.copyWith(
          intakeValues: [...targetSettings.intakeValues, value.second],
        );
      });
    }
  }

  void deleteIntake(double value) {
    setState(() {
      targetSettings = targetSettings.copyWith(
        intakeValues:
            targetSettings.intakeValues.where((v) => v != value).toList(),
      );
    });
  }
}
