import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../../model/target_settings.dart';
import '../icon.dart';
import '../size.dart';

class IntakeOption extends StatelessWidget {
  final double value;
  final bool isButton;
  final TargetSettings targetSettings;

  const IntakeOption({
    super.key,
    required this.value,
    required this.isButton,
    required this.targetSettings,
  });

  @override
  Widget build(BuildContext context) {
    final label = value > 0
        ? targetSettings.volumeMeasureUnit.formatValue(value)
        : AppL10n.of(context).customIntake;
    final text = Text(label, style: TextStyle(fontWeight: FontWeight.w500));
    if (isButton) {
      return text;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: AppSize.spacingSmall,
      children: [AppIcon.waterGlass(context), text],
    );
  }
}
