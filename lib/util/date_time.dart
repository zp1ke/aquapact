import 'package:flutter/material.dart';

extension AppTime on TimeOfDay {
  TimeOfDay add(Duration duration) {
    final dateTime = DateTime(2025, 1, 1, hour, minute).add(duration);
    return TimeOfDay.fromDateTime(dateTime);
  }
}
