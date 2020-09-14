import 'dart:convert';

import 'package:client/api/models/monitoring_item.dart';
import 'package:http/http.dart' as http;

class MonitoringApi {
  String host;
  http.Client client;

  MonitoringApi(this.host) {
    client = http.Client();
  }

  String get apiUrl => 'http://$host:5560/api';

  Future<List<MonitoringItemModel>> getMonitoringData() async {
    var list = await _fetchGeneric('monitoring');

    return list.map<MonitoringItemModel>((d) => MonitoringItemModel.fromJson(d)).toList();
  }

  Future<dynamic> _fetchGeneric(String url, {query}) async {
    String uri = query == null ? '$apiUrl/$url' : '$apiUrl/$url?$query';
    final res = await client.get(uri);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load $url');
    }
  }
}
