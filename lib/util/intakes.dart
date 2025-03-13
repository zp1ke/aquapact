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
    IntakesService? intakesService,
    HealthService? healthService,
  }) async {
    final now = DateTime.now();
    final intakesServ = intakesService ?? IntakesService.get();
    var intake = await intakesServ.addIntake(
      amount: amount,
      measureUnit: measureUnit,
      dateTime: now,
    );
    if (healthSync) {
      final healthServ = healthService ?? HealthService.get();
      final synced = await healthServ.addIntake(intake);
      if (synced) {
        intake = intake.copyWith(healthSync: SyncStatus.synced);
        await intakesServ.updateIntake(intake);
      }
    }
    return intake;
  }
}
