import 'measure_unit.dart';

class Intake {
  final String code;
  final double amount;
  final DateTime dateTime;
  final VolumeMeasureUnit measureUnit;

  Intake({
    required this.code,
    required this.amount,
    required this.dateTime,
    required this.measureUnit,
  });
}
