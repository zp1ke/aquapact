import 'package:flutter/material.dart';

import '../../app/navigation.dart';
import '../../l10n/app_l10n.dart';
import '../../model/pair.dart';
import '../../model/target_settings.dart';
import '../../service/settings.dart';
import '../icon.dart';
import '../size.dart';
import 'controlled_checkbox.dart';

Future<Pair<TargetSettings, double>?> getCustomIntake(
  BuildContext context, {
  required String title,
  required TargetSettings targetSettings,
  double? initialValue,
  bool? save,
}) async {
  final amountController = TextEditingController();
  final saveController = CheckBoxController();
  if (initialValue != null) {
    amountController.text = targetSettings.volumeMeasureUnit.formatValue(
      initialValue,
      withSymbol: false,
    );
  }

  return showModalBottomSheet<Pair<TargetSettings, double>>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) {
      final appL10n = AppL10n.of(context);

      onSubmitted(String? text, bool saveValue) async {
        final value = double.tryParse(text ?? '');
        var resultSettings = targetSettings;
        if (saveValue && value != null) {
          resultSettings = targetSettings.copyWith(
            intakeValues: [...targetSettings.intakeValues, value],
          );
          final l10n = AppL10n.of(context);
          await SettingsService.get().saveTargetSettings(
            resultSettings,
            notificationTitle: l10n.notificationTitle,
            notificationMessage: l10n.notificationMessage,
            scheduleNotifications: false,
          );
        }
        if (context.mounted) {
          context.navigateBack(
              value != null && value > 0 ? Pair(resultSettings, value) : null);
        }
      }

      final saveValue = save ?? false;

      return Container(
        padding: MediaQuery.viewInsetsOf(context),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSize.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSize.spacingMedium,
            children: [
              Text(title),
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
                onSubmitted: (text) => onSubmitted(text, saveController.value),
                textAlign: TextAlign.right,
              ),
              Row(
                mainAxisAlignment: saveValue
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
                mainAxisSize: saveValue ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (saveValue) ...[
                    ControlledCheckBox(
                      text: appL10n.preserveValue,
                      controller: saveController,
                    ),
                    Spacer(),
                  ],
                  OutlinedButton(
                    onPressed: () => onSubmitted(
                        amountController.text, saveController.value),
                    child: Text(appL10n.save),
                  ),
                ],
              ),
              SizedBox(height: AppSize.spacingSmall / 2),
            ],
          ),
        ),
      );
    },
  );
}
