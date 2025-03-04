import '../model/measure_unit.dart';

abstract class HealthService {
  Future<bool> hasPermissionGranted();

  Future<bool> addIntake({
    required String intakeId,
    required double amount,
    required VolumeMeasureUnit measureUnit,
    required DateTime dateTime,
  });
}
