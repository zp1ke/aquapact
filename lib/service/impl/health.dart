import 'package:flutter/services.dart';

import '../../model/intake.dart';
import '../../model/measure_unit.dart';
import '../../util/logger.dart';
import '../health.dart';

class HealthChannelService extends HealthService {
  static const platform = MethodChannel('org.zp1ke.aquapact/health');

  @override
  Future<bool> hasPermissionGranted() async {
    try {
      final granted = await platform.invokeMethod<bool>('checkPermissions');
      return granted ?? false;
    } on PlatformException catch (e, stack) {
      'Failed to add intake: ${e.message}'
          .logError(error: e, stackTrace: stack);
      return false;
    }
  }

  @override
  Future<bool> addIntake(Intake intake) async {
    try {
      final amountInLiters = intake.measureUnit
          .convertAmountTo(intake.amount, VolumeMeasureUnit.l);
      final data = {
        'intakeId': intake.code,
        'valueInLiters': amountInLiters,
        'dateTimeMillis': intake.dateTime.millisecondsSinceEpoch,
      };
      final added = await platform.invokeMethod<bool>('addIntake', data);
      return added ?? false;
    } on PlatformException catch (e, stack) {
      'Failed to add intake: ${e.message}'
          .logError(error: e, stackTrace: stack);
      return false;
    }
  }
}
