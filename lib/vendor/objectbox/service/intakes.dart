import '../../../model/intake.dart';
import '../../../model/measure_unit.dart';
import '../../../service/intakes.dart';
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

  Intake _toIntake(IntakeBox intake) {
    final measureUnit = VolumeMeasureUnit.values
        .firstWhere((element) => element.symbol == intake.measureUnit!);
    return Intake(
      amount: intake.amount!,
      dateTime: intake.dateTime!,
      measureUnit: measureUnit,
    );
  }
}
