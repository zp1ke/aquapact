import 'package:flutter/material.dart';

import '../../app/di.dart';
import '../../model/target_settings.dart';
import '../../service/intakes.dart';
import '../icon.dart';
import '../size.dart';
import '../widget/custom_intake.dart';
import '../widget/intake_option.dart';
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
        values: [...targetSettings.intakeValues, -1.0],
        icon: AppIcon.add,
        onSelected: addIntake,
        itemBuilder: (_, value, isButton) => IntakeOption(
          targetSettings: targetSettings,
          value: value,
          isButton: isButton,
        ),
        onSelectedTransform: (_, value) {
          if (value <= 0) {
            return getCustomIntake(context, targetSettings: targetSettings);
          }
          return Future.value(value);
        },
      ),
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
