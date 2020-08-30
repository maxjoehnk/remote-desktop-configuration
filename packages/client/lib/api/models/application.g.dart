// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) {
  return ApplicationModel(
    cursor: json['cursor'] as String,
    name: json['name'] as String,
    stream: json['stream'] as String,
    volume:
        (json['volume'] as List)?.map((e) => (e as num)?.toDouble())?.toList(),
    mute: json['mute'] as bool,
    icon: json['icon'] as String,
  );
}

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'name': instance.name,
      'stream': instance.stream,
      'volume': instance.volume,
      'mute': instance.mute,
      'icon': instance.icon,
    };
