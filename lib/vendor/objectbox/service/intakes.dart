import '../../../model/intake.dart';
import '../../../model/intake_range.dart';
import '../../../model/measure_unit.dart';
import '../../../model/range_type.dart';
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
    required DateTime dateTime,
    bool healthSynced = false,
  }) async {
    final intake = IntakeBox(
      amount: amount,
      dateTime: dateTime,
      measureUnit: measureUnit.symbol,
      healthSynced: healthSynced,
    );
    final saved = await box.putAndGetAsync(intake);
    return _toIntake(saved);
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
  Future<List<IntakeRange>> fetchAmounts({
    required DateTime from,
    required DateTime to,
  }) async {
    final intakes = <IntakeRange>[];
    final toDateTime = to.atStartOfDay().add(const Duration(days: 1));
    final days = to.difference(from).inDays;
    final rangeType = _rangeType(days);
    var dateTime = from.atStartOfDay();
    while (dateTime.isBefore(toDateTime)) {
      final nextDateTime =
          rangeType.nextDateTime(dateTime, days).min(toDateTime);
      final amount = await sumIntakesAmount(from: dateTime, to: nextDateTime);
      intakes.add(IntakeRange(
        amount: amount,
        from: dateTime,
        to: nextDateTime,
        measureUnit: VolumeMeasureUnit.ml,
        rangeType: rangeType,
      ));
      dateTime = nextDateTime;
    }
    return intakes;
  }

  @override
  Future<Intake> updateIntake(Intake intake) async {
    final intakeId = int.parse(intake.code);
    final query = box.query(IntakeBox_.id.equals(intakeId)).build();
    final intakeBox = query.findFirst();
    if (intakeBox != null) {
      intakeBox.amount = intake.amount;
      intakeBox.dateTime = intake.dateTime;
      intakeBox.healthSynced = intake.healthSynced;
      final saved = await box.putAndGetAsync(intakeBox);
      return _toIntake(saved);
    }
    return intake;
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
      healthSynced: intake.healthSynced ?? true,
    );
  }

  RangeType _rangeType(int days) {
    return switch (days) {
      > 365 => RangeType.yearly,
      <= 365 && > 180 => RangeType.monthly,
      <= 180 && > 30 => RangeType.twoWeeks,
      <= 30 && > 10 => RangeType.weekly,
      <= 10 || _ => RangeType.daily,
    };
  }
}
