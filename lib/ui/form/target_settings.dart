import 'package:flutter/material.dart';

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
  late TargetSettings targetSettings;

  @override
  void initState() {
    super.initState();
    targetSettings = widget.targetSettings ?? TargetSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.spacingMedium),
      child: Column(
        spacing: AppSize.spacingMedium,
        children: [
          dailyTargetCard(context),
          Expanded(child: Spacer()),
          OutlinedButton(onPressed: () {}, child: Text('TODO')),
        ],
      ),
    );
  }

  Widget dailyTargetCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSize.spacingMedium),
        child: Column(
          spacing: AppSize.spacingLarge,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              interval: 1000,
              onChanged: (value) {
                setState(() {
                  targetSettings.dailyTarget = value.roundToNearestHundred();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
