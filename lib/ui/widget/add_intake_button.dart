import 'package:flutter/material.dart';

import '../../app/di.dart';
import '../../model/target_settings.dart';
import '../../service/intakes.dart';
import '../icon.dart';
import '../size.dart';
import 'popup_button.dart';

class AddIntakeButton extends StatelessWidget {
  final TargetSettings targetSettings;
  final VoidCallback? onAdding;
  final Function(double) onAdded;
  final bool enabled;

  const AddIntakeButton({
    super.key,
    required this.targetSettings,
    this.onAdding,
    required this.onAdded,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.spacingSmall),
      child: PopupButton<double>(
        enabled: enabled,
        value: targetSettings.defaultIntakeValue,
        values: targetSettings.intakeValues,
        icon: AppIcon.add,
        onSelected: addIntake,
        itemBuilder: intakeWidget,
      ),
    );
  }

  Widget intakeWidget(BuildContext context, double value, bool isButton) {
    final text = Text(
      targetSettings.volumeMeasureUnit.formatValue(value),
      style: TextStyle(
        fontWeight: FontWeight.w500,
      ),
    );
    if (isButton) {
      return text;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSize.spacingSmall,
      children: [
        AppIcon.waterGlass(context),
        text,
      ],
    );
  }

  void addIntake(double value) async {
    if (onAdding != null) {
      onAdding!();
    }
    await service<IntakesService>().addIntake(
      amount: value,
      measureUnit: targetSettings.volumeMeasureUnit,
    );
    onAdded(value);
  }
}
