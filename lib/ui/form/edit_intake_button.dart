import 'package:flutter/material.dart';

import '../../model/target_settings.dart';
import '../icon.dart';
import '../size.dart';
import 'popup_button.dart';

class EditIntakeButton extends StatelessWidget {
  final TargetSettings targetSettings;
  final double value;
  final Function(double) onChanged;
  final bool enabled;

  const EditIntakeButton({
    super.key,
    required this.targetSettings,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.spacingSmall),
      child: PopupButton<double>(
        enabled: enabled,
        value: value,
        elevated: false,
        disableValue: true,
        values: targetSettings.intakeValues,
        onSelected: onChanged,
        itemBuilder: intakeWidget,
      ),
    );
  }

  Widget intakeWidget(BuildContext context, double value, _) {
    final text = Text(
      targetSettings.volumeMeasureUnit.formatValue(value),
      style: TextStyle(
        fontWeight: FontWeight.w500,
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: AppSize.spacingSmall,
      children: [
        AppIcon.waterGlass(context),
        text,
      ],
    );
  }
}
