import '../app/di.dart';
import '../model/intake.dart';

abstract class HealthService {
  static HealthService get() => service<HealthService>();

  Future<bool> hasPermissionGranted();

  Future<bool> addIntake(Intake intake);
}
