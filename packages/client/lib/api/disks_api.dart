import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:client/api/models/mount.dart';

class DisksApi {
  String host;
  http.Client client;

  DisksApi(this.host) {
    client = http.Client();
  }

  String get apiUrl => 'http://$host:5560/api';

  Future<List<MountModel>> listMounts() async {
    var list = await _fetchGeneric('disks');

    return list.map<MountModel>((d) => MountModel.fromJson(d)).toList();
  }

  Future<dynamic> _fetchGeneric(String url, {query}) async {
    String uri = query == null ? '$apiUrl/$url' : '$apiUrl/$url?$query';
    log("GET $uri");
    final res = await client.get(uri);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load $url');
    }
  }
}
