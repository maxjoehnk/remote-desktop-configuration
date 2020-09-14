// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) {
  return GameModel(
    slug: json['slug'] as String,
    name: json['name'] as String,
    platform: json['platform'] as String,
    runner: json['runner'] as String,
  );
}

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'platform': instance.platform,
      'runner': instance.runner,
    };
