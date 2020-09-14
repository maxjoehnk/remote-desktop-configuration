// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitoringItemModel _$MonitoringItemModelFromJson(Map<String, dynamic> json) {
  return MonitoringItemModel(
    name: json['name'] as String,
    current: json['current'] == null
        ? null
        : MonitoringValueModel.fromJson(
            json['current'] as Map<String, dynamic>),
    history: (json['history'] as List)
        ?.map((e) => e == null
            ? null
            : MonitoringValueModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MonitoringItemModelToJson(
        MonitoringItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'current': instance.current,
      'history': instance.history,
    };
