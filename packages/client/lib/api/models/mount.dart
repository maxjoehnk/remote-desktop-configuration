import 'package:json_annotation/json_annotation.dart';

part 'mount.g.dart';

@JsonSerializable()
class MountModel {
  final String path;
  final String name;
  final int free;
  final int total;
  final int used;

  MountModel({ this.path, this.name, this.free, this.total, this.used });

  factory MountModel.fromJson(Map<String, dynamic> json) =>
      _$MountModelFromJson(json);

  @override
  String toString() {
    return '{ path: $path, name: $name, free: $free, total: $total, used: $used }';
  }
}
