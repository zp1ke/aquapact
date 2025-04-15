import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../../model/target_settings.dart';
import '../icon.dart';
import '../size.dart';

Future<double?> getCustomIntake(
  BuildContext context, {
  required TargetSettings targetSettings,
  double? initialValue,
}) async {
  final amountController = TextEditingController();
  if (initialValue != null) {
    amountController.text = targetSettings.volumeMeasureUnit.formatValue(
      initialValue,
      withSymbol: false,
    );
  }

  return showModalBottomSheet<double>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final appL10n = AppL10n.of(context);

      onSubmitted(String? text) {
        final value = double.tryParse(text ?? '');
        Navigator.pop(context, value != null && value > 0 ? value : null);
      }

      return Container(
        padding: MediaQuery.viewInsetsOf(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSize.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSize.spacingMedium,
            children: [
              Text(appL10n.enterCustomIntake),
              TextField(
                autofocus: true,
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText:
                      appL10n.intakeIn(targetSettings.volumeMeasureUnit.symbol),
                  prefixIcon: AppIcon.waterGlass(context),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: onSubmitted,
                textAlign: TextAlign.right,
              ),
              OutlinedButton(
                onPressed: () => onSubmitted(amountController.text),
                child: Text(appL10n.save),
              ),
            ],
          ),
        ),
      );
    },
  );
}
