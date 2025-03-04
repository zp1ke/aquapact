import '../model/measure_unit.dart';

abstract class HealthService {
  Future<bool> addIntake({
    required double amount,
    required VolumeMeasureUnit measureUnit,
    required DateTime dateTime,
  });
}
