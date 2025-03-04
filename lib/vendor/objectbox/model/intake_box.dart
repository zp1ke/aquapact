import 'package:objectbox/objectbox.dart';

@Entity()
class IntakeBox {
  int id;

  @Property(type: PropertyType.float)
  double? amount;

  @Index()
  @Property(type: PropertyType.date)
  DateTime? dateTime;

  String? measureUnit;

  bool? healthSynced;

  IntakeBox({
    this.id = 0,
    this.amount,
    this.dateTime,
    this.measureUnit,
    this.healthSynced = false,
  });
}
