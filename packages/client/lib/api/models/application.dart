import 'package:json_annotation/json_annotation.dart';

part 'application.g.dart';

@JsonSerializable()
class ApplicationModel {
  final String cursor;
  final String name;
  final String stream;
  final List<double> volume;
  final bool mute;
  final String icon;

  ApplicationModel({ this.cursor, this.name, this.stream, this.volume, this.mute, this.icon });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationModelFromJson(json);
}
