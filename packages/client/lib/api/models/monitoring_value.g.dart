// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitoringValueModel _$MonitoringValueModelFromJson(Map<String, dynamic> json) {
  return MonitoringValueModel(
    value: (json['value'] as num)?.toDouble(),
    max: (json['max'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$MonitoringValueModelToJson(
        MonitoringValueModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'max': instance.max,
    };
