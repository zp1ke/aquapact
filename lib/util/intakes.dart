import '../app/di.dart';
import '../model/intake.dart';
import '../model/measure_unit.dart';
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
    var healthSynced = false;
    final now = DateTime.now();
    if (healthSync) {
      healthSynced = await service<HealthService>().addIntake(
        amount: amount,
        measureUnit: measureUnit,
        dateTime: now,
      );
    }
    final intake = await service<IntakesService>().addIntake(
      amount: amount,
      measureUnit: measureUnit,
      dateTime: now,
      healthSynced: healthSynced,
    );
    return intake;
  }
}
