import 'package:flutter/services.dart';

import '../../model/measure_unit.dart';
import '../../util/logger.dart';
import '../health.dart';

class HealthChannelService extends HealthService {
  static const platform = MethodChannel('org.zp1ke.aquapact/health');

  @override
  Future<bool> addIntake({
    required double amount,
    required VolumeMeasureUnit measureUnit,
    required DateTime dateTime,
  }) async {
    try {
      final amountInLiters =
          measureUnit.convertAmountTo(amount, VolumeMeasureUnit.l);
      final data = {
        'value': amountInLiters,
        'dateTimeMillis': dateTime.millisecondsSinceEpoch,
      };
      await platform.invokeMethod<void>('addIntake', data);
      return true;
    } on PlatformException catch (e, stack) {
      'Failed to add intake: ${e.message}'
          .logError(error: e, stackTrace: stack);
      return false;
    }
  }
}
