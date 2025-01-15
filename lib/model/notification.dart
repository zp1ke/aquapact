import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../util/date_time.dart';

part 'notification.g.dart';

@JsonSerializable()
class AppNotification {
  final int id;

  final String title;

  final String body;

  @TimeOfDayConverter()
  final TimeOfDay time;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) =>
      _$AppNotificationFromJson(map);

  Map<String, dynamic> toMap() => _$AppNotificationToJson(this);
}
