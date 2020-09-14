import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class GameModel {
  final String slug;
  final String name;
  final String platform;
  final String runner;

  GameModel({ this.slug, this.name, this.platform, this.runner });

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);
}
