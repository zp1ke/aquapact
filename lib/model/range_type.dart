enum RangeType {
  daily,
  weekly,
  twoWeeks,
  monthly,
  yearly;

  DateTime nextDateTime(DateTime dateTime, int totalDaysInterval) {
    return switch (this) {
      .daily => dateTime.add(const Duration(days: 1)),
      .weekly => dateTime.add(const Duration(days: 7)),
      .twoWeeks => dateTime.add(Duration(days: totalDaysInterval ~/ 10)),
      .monthly => DateTime(dateTime.year, dateTime.month + 1, 1),
      .yearly => DateTime(dateTime.year + 1, 1, 1),
    };
  }
}
