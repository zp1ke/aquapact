import '../model/intake.dart';
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
  });
}
