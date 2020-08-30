import 'package:json_annotation/json_annotation.dart';

part 'device_channel.g.dart';

@JsonSerializable()
class DeviceChannelModel {
  final String cursor;
  final String name;
  final List<double> volume;
  final bool mute;

  DeviceChannelModel({this.cursor, this.name, this.volume, this.mute});

  factory DeviceChannelModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceChannelModelFromJson(json);
}
