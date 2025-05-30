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
    return _saveHealthSync(
      intake: intake,
      healthSync: healthSync,
      intakesService: intakesServ,
      healthService: healthService,
    );
  }

  Future<Intake> editIntake({
    required Intake intake,
    required bool healthSync,
    IntakesService? intakesService,
    HealthService? healthService,
  }) async {
    final intakesServ = intakesService ?? IntakesService.get();
    var updated = await intakesServ.updateIntake(intake);
    return _saveHealthSync(
      intake: updated,
      healthSync: healthSync,
      intakesService: intakesServ,
      healthService: healthService,
    );
  }

  Future<void> deleteIntake({
    required Intake intake,
    required bool healthSync,
    IntakesService? intakesService,
    HealthService? healthService,
  }) async {
    final intakesServ = intakesService ?? IntakesService.get();
    await intakesServ.deleteIntake(intake);
    if (healthSync) {
      final healthServ = healthService ?? HealthService.get();
      await healthServ.deleteIntake(intake);
    }
  }

  Future<Intake> _saveHealthSync({
    required Intake intake,
    required bool healthSync,
    required IntakesService intakesService,
    HealthService? healthService,
  }) async {
    if (healthSync) {
      final healthServ = healthService ?? HealthService.get();
      final recordId = await healthServ.saveIntake(intake);
      if (recordId != null) {
        final updated = intake.copyWith(
          healthSync: SyncStatus.synced,
          healthSyncId: recordId,
        );
        return intakesService.updateIntake(updated);
      }
    }
    return intake;
  }
}
