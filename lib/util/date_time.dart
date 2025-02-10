import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

extension AppTime on TimeOfDay {
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

extension AppDateTime on DateTime {
  DateTime atStartOfDay() => DateTime(year, month, day);
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
