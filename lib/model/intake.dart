import 'measure_unit.dart';

class Intake {
  final double amount;
  final DateTime dateTime;
  final VolumeMeasureUnit measureUnit;

  Intake({
    required this.amount,
    required this.dateTime,
    required this.measureUnit,
  });
}
