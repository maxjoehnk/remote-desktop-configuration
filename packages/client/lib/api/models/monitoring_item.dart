import 'package:client/api/models/monitoring_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'monitoring_item.g.dart';

@JsonSerializable()
class MonitoringItemModel {
  final String name;
  final MonitoringValueModel current;
  final List<MonitoringValueModel> history;

  MonitoringItemModel({ this.name, this.current, this.history });

  factory MonitoringItemModel.fromJson(Map<String, dynamic> json) =>
      _$MonitoringItemModelFromJson(json);
}
