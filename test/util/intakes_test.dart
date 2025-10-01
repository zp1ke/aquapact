import 'dart:io';

import 'package:aquapact/model/intake.dart';
import 'package:aquapact/model/measure_unit.dart';
import 'package:aquapact/model/sync_status.dart';
import 'package:aquapact/service/health.dart';
import 'package:aquapact/util/intakes.dart';
import 'package:aquapact/vendor/objectbox/object_box.dart';
import 'package:aquapact/vendor/objectbox/service/intakes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final tempDir = await Directory.systemTemp.createTemp('aquapact_');
  final objectBox = await ObjectBox.createOn(tempDir);
  final intakesService = BoxIntakesService(objectBox);
  final healthService = FakeHealthService();

  test('IntakesHandler.addIntake() when HealthService add intake', () async {
    healthService.addIntakeResult = true;
    final intake = await IntakesHandler().addIntake(
      amount: 1.0,
      measureUnit: VolumeMeasureUnit.ml,
      healthSync: true,
      intakesService: intakesService,
      healthService: healthService,
    );
    expect(intake.code, isNotNull);
    expect(intake.amount, 1.0);
    expect(intake.healthSync, SyncStatus.synced);
  });

  test(
    'IntakesHandler.addIntake() when HealthService cannot add intake',
    () async {
      healthService.addIntakeResult = false;
      final intake = await IntakesHandler().addIntake(
        amount: 1.0,
        measureUnit: VolumeMeasureUnit.ml,
        healthSync: true,
        intakesService: intakesService,
        healthService: healthService,
      );
      expect(intake.code, isNotNull);
      expect(intake.amount, 1.0);
      expect(intake.healthSync, SyncStatus.notSynced);

      healthService.addIntakeResult = true;
      final intake2 = await IntakesHandler().addIntake(
        amount: 1.0,
        measureUnit: VolumeMeasureUnit.ml,
        healthSync: false,
        intakesService: intakesService,
        healthService: healthService,
      );
      expect(intake2.code, isNotNull);
      expect(intake2.amount, 1.0);
      expect(intake2.healthSync, SyncStatus.notSynced);
    },
  );
}

class FakeHealthService extends HealthService {
  bool addIntakeResult = true;

  @override
  Future<String?> saveIntake(Intake intake) async {
    return Future.value(addIntakeResult ? DateTime.now().toString() : null);
  }

  @override
  Future<bool> hasPermissionGranted() {
    return Future.value(true);
  }

  @override
  Future<bool> deleteIntake(Intake intake) {
    return Future.value(addIntakeResult);
  }
}
