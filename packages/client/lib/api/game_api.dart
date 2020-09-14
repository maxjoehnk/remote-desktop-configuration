import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:client/api/models/game.dart';

class GameApi {
  String host;
  http.Client client;

  GameApi(this.host) {
    client = http.Client();
  }

  String get apiUrl => 'http://$host:5560/api';

  Future<List<GameModel>> listGames() async {
    var list = await _fetchGeneric('games');

    return list.map<GameModel>((d) => GameModel.fromJson(d)).toList();
  }

  String getBannerUrl(String cursor) {
    return '$apiUrl/games/$cursor/banner';
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
