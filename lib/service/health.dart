import '../model/intake.dart';

abstract class HealthService {
  Future<bool> hasPermissionGranted();

  Future<bool> addIntake(Intake intake);
}
