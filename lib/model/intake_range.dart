import 'package:flutter/material.dart';

import '../l10n/app_l10n.dart';
import '../util/date_time.dart';
import 'measure_unit.dart';
import 'range_type.dart';

class IntakeRange {
  final DateTime from;
  final DateTime to;
  final double amount;
  final VolumeMeasureUnit measureUnit;
  final RangeType rangeType;

  IntakeRange({
    required this.from,
    required this.to,
    required this.amount,
    required this.measureUnit,
    required this.rangeType,
  });

  String label(BuildContext context) {
    if (from.isToday) {
      return AppL10n.of(context).today;
    }
    if (from.isSameDay(to)) {
      return from.day.toString();
    }
    return switch (rangeType) {
      RangeType.daily => from.day.toString(),
      RangeType.weekly || RangeType.twoWeeks =>
        from.isSameMonth(to)
            ? '${from.day} - ${to.day}'
            : '${from.day}/${from.month} - ${to.day}/${to.month}',
      RangeType.monthly => '${from.month}/${from.year}',
      RangeType.yearly => '${from.year}',
    };
  }
}
