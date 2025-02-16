import '../../../model/intake.dart';
import '../../../model/measure_unit.dart';
import '../../../service/intakes.dart';
import '../../../util/date_time.dart';
import '../model/intake_box.dart';
import '../object_box.dart';
import '../objectbox.g.dart';

// https://docs.objectbox.io/queries
class BoxIntakesService extends IntakesService {
  final Box<IntakeBox> box;

  BoxIntakesService(ObjectBox objectBox)
      : box = objectBox.store.box<IntakeBox>();

  @override
  Future<Intake> addIntake({
    required double amount,
    required VolumeMeasureUnit measureUnit,
  }) async {
    final intake = IntakeBox(
      amount: amount,
      dateTime: DateTime.now(),
      measureUnit: measureUnit.symbol,
    );
    await box.putAsync(intake);
    return _toIntake(intake);
  }

  @override
  Future<List<Intake>> fetchIntakes({
    required DateTime from,
    required DateTime to,
    int? limit,
  }) async {
    final query = (box.query(IntakeBox_.dateTime.betweenDate(from, to))
          ..order(IntakeBox_.dateTime, flags: Order.descending))
        .build();
    if (limit != null) {
      query.limit = limit;
    }
    final intakes = await query.stream().map(_toIntake).toList();
    query.close();
    return intakes;
  }

  @override
  Future<double> sumIntakesAmount({
    required DateTime from,
    required DateTime to,
  }) {
    final query = box.query(IntakeBox_.dateTime.betweenDate(from, to)).build();
    final sum = query.property(IntakeBox_.amount).sum();
    query.close();
    return Future.value(sum);
  }

  @override
  Future<List<Intake>> fetchAmounts({
    required DateTime from,
    required DateTime to,
  }) async {
    final intakes = <Intake>[];
    final toDateTime = to.atStartOfDay().add(const Duration(days: 1));
    var dateTime = from.atStartOfDay();
    while (dateTime.isBefore(toDateTime)) {
      final nextDateTime = dateTime.add(const Duration(days: 1));
      final amount = await sumIntakesAmount(from: dateTime, to: nextDateTime);
      intakes.add(Intake(
        code: dateTime.millisecondsSinceEpoch.toString(),
        amount: amount,
        dateTime: dateTime,
        measureUnit: VolumeMeasureUnit.ml,
      ));
      dateTime = nextDateTime;
    }
    return intakes;
  }

  @override
  Future<void> deleteIntake(Intake intake) {
    final intakeId = int.parse(intake.code);
    final query = box.query(IntakeBox_.id.equals(intakeId)).build();
    return query.removeAsync();
  }

  Intake _toIntake(IntakeBox intake) {
    final measureUnit = VolumeMeasureUnit.values
        .firstWhere((element) => element.symbol == intake.measureUnit!);
    return Intake(
      code: intake.id.toString(),
      amount: intake.amount!,
      dateTime: intake.dateTime!,
      measureUnit: measureUnit,
    );
  }
}
