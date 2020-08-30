// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceChannelModel _$DeviceChannelModelFromJson(Map<String, dynamic> json) {
  return DeviceChannelModel(
    cursor: json['cursor'] as String,
    name: json['name'] as String,
    volume:
        (json['volume'] as List)?.map((e) => (e as num)?.toDouble())?.toList(),
    mute: json['mute'] as bool,
  );
}

Map<String, dynamic> _$DeviceChannelModelToJson(DeviceChannelModel instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'name': instance.name,
      'volume': instance.volume,
      'mute': instance.mute,
    };
