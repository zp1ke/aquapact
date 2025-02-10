import '../../model/intake.dart';
import '../../model/measure_unit.dart';
import '../intakes.dart';

class IntakesFakeService implements IntakesService {
  final List<Intake> _intakes = [];

  @override
  Future<List<Intake>> fetchIntakes({
    required DateTime from,
    required DateTime to,
    int? limit,
  }) {
    final items = _intakes.where((element) {
      return element.dateTime.isAfter(from) && element.dateTime.isBefore(to);
    }).toList();
    items.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (limit != null) {
      return Future.value(items.take(limit).toList());
    }
    return Future.value(items);
  }

  @override
  Future<Intake> addIntake({
    required double amount,
    required VolumeMeasureUnit measureUnit,
  }) {
    final intake = Intake(
      amount: amount,
      measureUnit: measureUnit,
      dateTime: DateTime.now(),
    );
    _intakes.insert(0, intake);
    return Future.value(intake);
  }
}
