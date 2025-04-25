import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../../model/pair.dart';
import '../../model/target_settings.dart';
import '../../util/intakes.dart';
import '../icon.dart';
import '../size.dart';
import '../widget/custom_intake.dart';
import '../widget/intake_option.dart';
import 'popup_button.dart';

class AddIntakeButton extends StatelessWidget {
  final TargetSettings targetSettings;
  final VoidCallback? onAdding;
  final Function(Pair<TargetSettings, double>) onAdded;
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
      child: PopupButton<TargetSettings, double>(
        enabled: enabled,
        extra: targetSettings,
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
          if (value.second <= 0) {
            return getCustomIntake(
              context,
              title: AppL10n.of(context).enterCustomIntake,
              targetSettings: targetSettings,
              save: true,
            );
          }
          return Future.value(value);
        },
      ),
    );
  }

  void addIntake(Pair<TargetSettings, double> value) async {
    if (onAdding != null) {
      onAdding!();
    }
    await IntakesHandler().addIntake(
      amount: value.second,
      measureUnit: targetSettings.volumeMeasureUnit,
      healthSync: targetSettings.healthSync,
    );
    onAdded(value);
  }
}
