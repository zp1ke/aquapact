import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

extension AppTime on TimeOfDay {
  TimeOfDay add(Duration duration) {
    final dateTime = DateTime(2025, 1, 1, hour, minute).add(duration);
    return TimeOfDay.fromDateTime(dateTime);
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
