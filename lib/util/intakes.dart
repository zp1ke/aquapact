import '../app/di.dart';
import '../model/intake.dart';
import '../model/measure_unit.dart';
import '../model/sync_status.dart';
import '../service/health.dart';
import '../service/intakes.dart';

class IntakesHandler {
  IntakesHandler._();

  static final IntakesHandler _instance = IntakesHandler._();

  factory IntakesHandler() => _instance;

  Future<Intake> addIntake({
    required double amount,
    required VolumeMeasureUnit measureUnit,
    required bool healthSync,
  }) async {
    final now = DateTime.now();
    var intake = await service<IntakesService>().addIntake(
      amount: amount,
      measureUnit: measureUnit,
      dateTime: now,
    );
    if (healthSync) {
      final synced = await service<HealthService>().addIntake(intake);
      if (synced) {
        intake = intake.copyWith(healthSync: SyncStatus.synced);
        await service<IntakesService>().updateIntake(intake);
      }
    }
    return intake;
  }
}
