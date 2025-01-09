import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../l10n/app_l10n.dart';
import '../../model/target_settings.dart';
import '../../util/number.dart';
import '../size.dart';
import '../widget/slider.dart';

class TargetSettingsForm extends StatefulWidget {
  final TargetSettings? targetSettings;
  final Function(TargetSettings) onSave;

  const TargetSettingsForm({
    super.key,
    this.targetSettings,
    required this.onSave,
  });

  @override
  State<TargetSettingsForm> createState() => _TargetSettingsFormState();
}

class _TargetSettingsFormState extends State<TargetSettingsForm> {
  TargetSettings targetSettings = TargetSettings();

  @override
  void initState() {
    super.initState();
    if (widget.targetSettings != null) {
      targetSettings = widget.targetSettings!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.spacingMedium),
      child: Column(
        spacing: AppSize.spacingMedium,
        children: [
          card(dailyTargetCard(context)),
          card(wakeUpSleepTimesCard(context)),
          card(notificationIntervalCard(context)),
          SizedBox(height: AppSize.spacingLarge),
          OutlinedButton(
            onPressed: () {
              widget.onSave(targetSettings);
            },
            child: Text(AppL10n.of(context).save),
          ),
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

  Widget dailyTargetCard(BuildContext context) {
    return Column(
      spacing: AppSize.spacingLarge,
      children: [
        Text(
          '${AppL10n.of(context).dailyWaterIntake} (${targetSettings.volumeMeasureUnit.symbol})',
          style: TextTheme.of(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SliderWidget(
          value: targetSettings.dailyTarget,
          min: 500.0,
          max: 5000.0,
          interval: 1000.0,
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

  Widget wakeUpSleepTimesCard(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Column(
      spacing: AppSize.spacingMedium,
      children: [
        Text(
          l10n.wakeUpSleepTimes(
            targetSettings.wakeUpTime.format(context),
            targetSettings.sleepTime.format(context),
          ),
          style: TextTheme.of(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        OutlinedButton(
          onPressed: () {
            editWakeUpSleepTimes(context);
          },
          child: Text(l10n.edit),
        ),
      ],
    );
  }

  void editWakeUpSleepTimes(BuildContext context) async {
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
      use24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
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

  Widget notificationIntervalCard(BuildContext context) {
    return Column(
      spacing: AppSize.spacingLarge,
      children: [
        Text(
          AppL10n.of(context)
              .notifyEveryHours(targetSettings.notificationInterval.inHours),
          style: TextTheme.of(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SliderWidget(
          value: targetSettings.notificationInterval.inHours.toDouble(),
          min: 1.0,
          max: 4.0,
          interval: 1.0,
          onChanged: (value) {
            setState(() {
              targetSettings = targetSettings.copyWith(
                notificationIntervalInMinutes: (value * 60).toInt(),
              );
            });
          },
        ),
      ],
    );
  }
}
