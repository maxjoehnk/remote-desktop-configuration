import 'package:json_annotation/json_annotation.dart';

part 'monitoring_value.g.dart';

@JsonSerializable()
class MonitoringValueModel {
  final double value;
  final double max;

  MonitoringValueModel({ this.value, this.max });

  factory MonitoringValueModel.fromJson(Map<String, dynamic> json) =>
      _$MonitoringValueModelFromJson(json);
}
