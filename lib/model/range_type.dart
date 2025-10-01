enum RangeType {
  daily,
  weekly,
  twoWeeks,
  monthly,
  yearly;

  DateTime nextDateTime(DateTime dateTime, int totalDaysInterval) {
    return switch (this) {
      RangeType.daily => dateTime.add(const Duration(days: 1)),
      RangeType.weekly => dateTime.add(const Duration(days: 7)),
      RangeType.twoWeeks => dateTime.add(
        Duration(days: totalDaysInterval ~/ 10),
      ),
      RangeType.monthly => DateTime(dateTime.year, dateTime.month + 1, 1),
      RangeType.yearly => DateTime(dateTime.year + 1, 1, 1),
    };
  }
}
