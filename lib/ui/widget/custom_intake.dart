import 'package:flutter/material.dart';

import '../../app/navigation.dart';
import '../../l10n/app_l10n.dart';
import '../../model/target_settings.dart';
import '../../service/settings.dart';
import '../icon.dart';
import '../size.dart';

Future<double?> getCustomIntake(
  BuildContext context, {
  required String title,
  required TargetSettings targetSettings,
  double? initialValue,
  bool? save,
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
    useSafeArea: true,
    builder: (context) {
      final appL10n = AppL10n.of(context);

      onSubmitted(String? text, bool saveValue) async {
        final value = double.tryParse(text ?? '');
        if (saveValue && value != null) {
          final newSettings = targetSettings.copyWith(
            intakeValues: [...targetSettings.intakeValues, value],
          );
          final l10n = AppL10n.of(context);
          await SettingsService.get().saveTargetSettings(
            newSettings,
            notificationTitle: l10n.notificationTitle,
            notificationMessage: l10n.notificationMessage,
            scheduleNotifications: false,
          );
        }
        if (context.mounted) {
          context.navigateBack(value != null && value > 0 ? value : null);
        }
      }

      final saveValue = save ?? false;
      var mustSave = false;

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
                onSubmitted: (text) => onSubmitted(text, mustSave),
                textAlign: TextAlign.right,
              ),
              Row(
                mainAxisAlignment: saveValue
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                mainAxisSize: saveValue ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (saveValue)
                    Checkbox.adaptive(
                      value: mustSave,
                      onChanged: (value) {
                        mustSave = value ?? false;
                      },
                    ),
                  OutlinedButton(
                    onPressed: () =>
                        onSubmitted(amountController.text, mustSave),
                    child: Text(appL10n.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
