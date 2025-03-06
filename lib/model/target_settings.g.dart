// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetSettings _$TargetSettingsFromJson(Map<String, dynamic> json) =>
    TargetSettings(
      dailyTarget: (json['dailyTarget'] as num?)?.toDouble() ?? 2500.0,
      volumeMeasureUnit: $enumDecodeNullable(
              _$VolumeMeasureUnitEnumMap, json['volumeMeasureUnit']) ??
          VolumeMeasureUnit.ml,
      intakeValues: (json['intakeValues'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [100.0, 250.0, 400.0, 500.0],
      defaultIntakeValue:
          (json['defaultIntakeValue'] as num?)?.toDouble() ?? 250.0,
      wakeUpTime: json['wakeUpTime'] == null
          ? const TimeOfDay(hour: 7, minute: 0)
          : const TimeOfDayConverter().fromJson(json['wakeUpTime'] as String),
      sleepTime: json['sleepTime'] == null
          ? const TimeOfDay(hour: 23, minute: 0)
          : const TimeOfDayConverter().fromJson(json['sleepTime'] as String),
      notificationIntervalInMinutes:
          (json['notificationIntervalInMinutes'] as num?)?.toInt() ?? 60,
      healthSync: json['healthSync'] as bool? ?? false,
    );

Map<String, dynamic> _$TargetSettingsToJson(TargetSettings instance) =>
    <String, dynamic>{
      'dailyTarget': instance.dailyTarget,
      'volumeMeasureUnit':
          _$VolumeMeasureUnitEnumMap[instance.volumeMeasureUnit]!,
      'intakeValues': instance.intakeValues,
      'defaultIntakeValue': instance.defaultIntakeValue,
      'wakeUpTime': const TimeOfDayConverter().toJson(instance.wakeUpTime),
      'sleepTime': const TimeOfDayConverter().toJson(instance.sleepTime),
      'notificationIntervalInMinutes': instance.notificationIntervalInMinutes,
      'healthSync': instance.healthSync,
    };

const _$VolumeMeasureUnitEnumMap = {
  VolumeMeasureUnit.ml: 'ml',
  VolumeMeasureUnit.l: 'l',
};
