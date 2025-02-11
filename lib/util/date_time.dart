import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../l10n/app_l10n.dart';

extension AppTime on TimeOfDay {
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

extension AppDateTime on DateTime {
  DateTime atStartOfDay() => DateTime(year, month, day);

  DateTime atEndOfDay() => DateTime(year, month, day, 23, 59, 59);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String format(BuildContext context) {
    final appL10n = AppL10n.of(context);
    if (isToday) {
      final dateFormat = DateFormat.Hm(appL10n.localeName);
      return appL10n.todayAt(dateFormat.format(this));
    }
    final dateFormat = DateFormat.yMd(appL10n.localeName).add_Hm();
    return dateFormat.format(this);
  }

  String formatDate(BuildContext context) {
    final appL10n = AppL10n.of(context);
    if (isToday) {
      return appL10n.today;
    }
    final dateFormat = DateFormat.yMd(appL10n.localeName);
    return dateFormat.format(this);
  }
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  String toJson(TimeOfDay object) => '${object.hour}:${object.minute}';
}
