import 'dart:io';

import 'package:aquapact/model/measure_unit.dart';
import 'package:aquapact/model/sync_status.dart';
import 'package:aquapact/vendor/objectbox/object_box.dart';
import 'package:aquapact/vendor/objectbox/service/intakes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final tempDir = await Directory.systemTemp.createTemp('aquapact_');
  final objectBox = await ObjectBox.createOn(tempDir);
  final service = BoxIntakesService(objectBox);

  test('BoxIntakesService.addIntake()', () async {
    final intake = await service.addIntake(
      amount: 1.0,
      measureUnit: VolumeMeasureUnit.ml,
      dateTime: DateTime.now(),
    );
    expect(intake.code, isNotNull);
    expect(intake.amount, 1.0);
    expect(intake.healthSync, SyncStatus.notSynced);
  });

  test('BoxIntakesService.updateIntake()', () async {
    final intake = await service.addIntake(
      amount: 1.0,
      measureUnit: VolumeMeasureUnit.ml,
      dateTime: DateTime.now(),
    );
    expect(intake.code, isNotNull);
    expect(intake.healthSync, SyncStatus.notSynced);

    final updated = await service.updateIntake(
      intake.copyWith(amount: 2.0, healthSync: SyncStatus.synced),
    );
    expect(updated.code, intake.code);
    expect(updated.amount, 2.0);
    expect(updated.healthSync, SyncStatus.synced);
  });
}
