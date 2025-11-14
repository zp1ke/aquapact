import 'package:flutter/services.dart';

import '../../model/intake.dart';
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
      'Failed to check permissions: ${e.message}'.logError(
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  @override
  Future<String?> saveIntake(Intake intake) async {
    try {
      final amountInLiters = intake.measureUnit.convertAmountTo(
        intake.amount,
        .l,
      );
      final data = {
        'intakeId': intake.code,
        'valueInLiters': amountInLiters,
        'dateTimeMillis': intake.dateTime.millisecondsSinceEpoch,
      };
      if (intake.healthSyncId != null) {
        data['recordId'] = intake.healthSyncId!;
      }
      final recordId = await platform.invokeMethod<String?>('saveIntake', data);
      return recordId;
    } on PlatformException catch (e, stack) {
      'Failed to save intake: ${e.message}'.logError(
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  @override
  Future<bool> deleteIntake(Intake intake) async {
    try {
      final data = {'intakeId': intake.code, 'recordId': intake.healthSyncId};
      final success = await platform.invokeMethod<bool>('deleteIntake', data);
      return success ?? false;
    } on PlatformException catch (e, stack) {
      'Failed to delete intake: ${e.message}'.logError(
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }
}
