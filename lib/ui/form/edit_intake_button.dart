import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../../model/pair.dart';
import '../../model/target_settings.dart';
import '../size.dart';
import '../widget/custom_intake.dart';
import '../widget/intake_option.dart';
import 'popup_button.dart';

class EditIntakeButton extends StatelessWidget {
  final TargetSettings targetSettings;
  final double value;
  final Function(Pair<TargetSettings, double>) onChanged;
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
      child: PopupButton<TargetSettings, double>(
        enabled: enabled,
        extra: targetSettings,
        value: value,
        elevated: false,
        disableValue: true,
        values: [...targetSettings.intakeValues, -1.0],
        onSelected: onChanged,
        itemBuilder: (_, value, _) => IntakeOption(
          targetSettings: targetSettings,
          value: value,
          isButton: false,
        ),
        onSelectedTransform: (_, val) {
          if (val.second <= 0) {
            return getCustomIntake(
              context,
              title: AppL10n.of(context).enterCustomIntake,
              targetSettings: targetSettings,
              initialValue: value,
              save: true,
            );
          }
          return Future.value(val);
        },
      ),
    );
  }
}
