import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../l10n/app_l10n.dart';
import '../../model/target_settings.dart';
import '../../util/number.dart';
import '../color.dart';
import '../size.dart';
import '../widget/slider.dart';

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
          card(dailyTargetCard()),
          card(wakeUpSleepTimesCard()),
          card(notificationIntervalCard()),
          SizedBox(height: AppSize.spacingLarge),
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
    final theme = Theme.of(context);
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
          enabled: !widget.saving,
          interval: 1000.0,
          fromColor: Colors.blue,
          toColor: theme.colorScheme.water,
          textColor: Colors.white,
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

  Widget notificationIntervalCard() {
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
          enabled: !widget.saving,
          interval: 1.0,
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

  Widget saveButton() {
    return OutlinedButton(
      onPressed: !widget.saving
          ? () {
              widget.onSave(targetSettings);
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSize.spacingMedium,
        children: [
          if (widget.saving)
            SizedBox(
              width: AppSize.spacingXM,
              height: AppSize.spacingXM,
              child: CircularProgressIndicator.adaptive(),
            ),
          Text(widget.saving
              ? AppL10n.of(context).saving
              : AppL10n.of(context).save),
        ],
      ),
    );
  }
}
