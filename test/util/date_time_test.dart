import 'package:aquapact/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  test('TimeOfDay.add() returns time plus duration', () {
    final time = TimeOfDay(hour: 10, minute: 0);
    final steps = <Duration, TimeOfDay>{
      Duration(minutes: 30): TimeOfDay(hour: 10, minute: 30),
      Duration(hours: 1): TimeOfDay(hour: 11, minute: 0),
      Duration(minutes: 70): TimeOfDay(hour: 11, minute: 10),
      Duration(hours: 1, minutes: 30): TimeOfDay(hour: 11, minute: 30),
      Duration(hours: 3, minutes: 25): TimeOfDay(hour: 13, minute: 25),
      Duration(hours: 4, minutes: 55): TimeOfDay(hour: 14, minute: 55),
      Duration(hours: 20, minutes: 35): TimeOfDay(hour: 6, minute: 35),
    };

    steps.forEach((duration, expected) {
      final result = time.add(duration);
      expect(result, equals(expected));
    });
  });
}
