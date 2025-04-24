import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../l10n/app_l10n.dart';

extension AppTime on TimeOfDay {
  /// Converts a [TimeOfDay] instance to a [DateTime] instance using the current date.
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

extension AppDateTime on DateTime {
  /// Returns a [DateTime] instance representing the start of the day (00:00:00).
  DateTime atStartOfDay() => DateTime(year, month, day);

  /// Returns a [DateTime] instance representing the end of the day (23:59:59).
  DateTime atEndOfDay() => DateTime(year, month, day, 23, 59, 59);

  /// Checks if the current [DateTime] instance represents today's date.
  bool get isToday => isSameDay(DateTime.now());

  /// Checks if the current [DateTime] instance is on the same day as [other].
  bool isSameDay(DateTime other) {
    return isSameMonth(other) && day == other.day;
  }

  /// Checks if the current [DateTime] instance is in the same month as [other].
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Returns the earlier of the current [DateTime] instance and [other].
  DateTime min(DateTime other) {
    return isBefore(other) ? this : other;
  }

  /// Formats the [DateTime] instance into a localized string based on the context.
  /// If the date is today, it includes "Today at" with the time.
  String format(BuildContext context) {
    final appL10n = AppL10n.of(context);
    if (isToday) {
      final dateFormat = DateFormat.Hm(appL10n.localeName);
      return appL10n.todayAt(dateFormat.format(this));
    }
    final dateFormat = DateFormat.yMd(appL10n.localeName).add_Hm();
    return dateFormat.format(this);
  }

  /// Formats the [DateTime] instance into a localized date string based on the context.
  /// If the date is today, it returns "Today".
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

  /// Converts a JSON string in the format "HH:mm" to a [TimeOfDay] instance.
  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// Converts a [TimeOfDay] instance to a JSON string in the format "HH:mm".
  @override
  String toJson(TimeOfDay object) => '${object.hour}:${object.minute}';
}
