import 'package:flutter/material.dart';

import '../l10n/app_l10n.dart';
import '../model/intake.dart';
import '../model/intake_range.dart';
import '../model/measure_unit.dart';

abstract class IntakesService {
  Future<List<Intake>> fetchIntakes({
    required DateTime from,
    required DateTime to,
    int? limit,
  });

  Future<Intake> addIntake({
    required double amount,
    required VolumeMeasureUnit measureUnit,
    required DateTime dateTime,
    bool healthSynced = false,
  });

  Future<double> sumIntakesAmount({
    required DateTime from,
    required DateTime to,
  });

  Future<List<IntakeRange>> fetchAmounts({
    required DateTime from,
    required DateTime to,
  });

  Future<Intake> updateIntake(Intake intake);

  Future<void> deleteIntake(Intake intake);

  /// Returns a tip for the user according to the current intake value and target value.
  String tip(
    BuildContext context, {
    required double intakeValue,
    required double targetValue,
  }) {
    final percent = intakeValue / targetValue;
    final appL10n = AppL10n.of(context);
    if (percent >= 1) {
      return appL10n.intakeMessage100;
    }
    final now = DateTime.now();
    if (percent < 0.01 && now.hour < 10) {
      return appL10n.intakeMessageMorning0;
    }
    if (percent <= 0.11) {
      return appL10n.intakeMessage10;
    }
    final isMidday = now.hour >= 10 && now.hour < 16;
    if (isMidday && percent >= 0.23 && percent <= 0.27) {
      return appL10n.intakeMessageMidday25;
    }
    if (percent <= 0.31) {
      return appL10n.intakeMessage30;
    }
    if (isMidday && percent >= 0.48 && percent <= 0.52) {
      return appL10n.intakeMessageMidday50;
    }
    if (percent >= 0.73 && percent <= 0.77 && now.hour >= 16 && now.hour < 21) {
      return appL10n.intakeMessageAfternoon75;
    }
    if (percent >= 0.88 && percent <= 0.92 && now.hour >= 21) {
      return appL10n.intakeMessageEvening90;
    }
    return appL10n.intakeMessageOf((percent * 100).toStringAsFixed(0));
  }
}
