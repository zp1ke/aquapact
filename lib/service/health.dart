import '../app/di.dart';
import '../model/intake.dart';

abstract class HealthService {
  static HealthService get() => service<HealthService>();

  Future<bool> hasPermissionGranted();

  /// Saves the given intake to the HealthConnect service and returns the record ID.
  ///
  /// The [intake] parameter contains the hydration data to be saved.
  ///
  /// Returns a [String] representing the HealthConnect record ID if successful.
  /// Returns null if the operation fails.
  Future<String?> saveIntake(Intake intake);

  /// Deletes the intake record from the HealthConnect service.
  ///
  /// The [intake] parameter contains the hydration data to be deleted.
  ///
  /// Returns true if the deletion was successful, false otherwise.
  Future<bool> deleteIntake(Intake intake);
}
