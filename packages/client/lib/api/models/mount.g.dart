// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MountModel _$MountModelFromJson(Map<String, dynamic> json) {
  return MountModel(
    path: json['path'] as String,
    name: json['name'] as String,
    free: json['free'] as int,
    total: json['total'] as int,
    used: json['used'] as int,
  );
}

Map<String, dynamic> _$MountModelToJson(MountModel instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'free': instance.free,
      'total': instance.total,
      'used': instance.used,
    };
