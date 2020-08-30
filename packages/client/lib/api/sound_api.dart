import 'dart:convert';

import 'package:client/api/models/application.dart';
import 'package:client/api/models/device_channel.dart';
import 'package:http/http.dart' as http;

class SoundApi {
  String host;
  http.Client client;

  SoundApi(this.host) {
    client = http.Client();
  }

  String get apiUrl => 'http://$host:5560/api';

  Future<List<DeviceChannelModel>> listOutputs() async {
    var list = await _fetchGeneric('sound/outputs');

    return list.map<DeviceChannelModel>((d) => DeviceChannelModel.fromJson(d)).toList();
  }

  Future<List<DeviceChannelModel>> listInputs() async {
    var list = await _fetchGeneric('sound/inputs');

    return list.map<DeviceChannelModel>((d) => DeviceChannelModel.fromJson(d)).toList();
  }

  Future<List<ApplicationModel>> listPlayback() async {
    var list = await _fetchGeneric('sound/applications/playback');

    return list.map<ApplicationModel>((d) => ApplicationModel.fromJson(d)).toList();
  }

  Future<List<ApplicationModel>> listRecording() async {
    var list = await _fetchGeneric('sound/applications/recording');

    return list.map<ApplicationModel>((d) => ApplicationModel.fromJson(d)).toList();
  }

  Future<void> changePlaybackVolume(String cursor, double volume) async {
    final res = await client.post('$apiUrl/sound/applications/playback/$cursor/volume/$volume');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
  }

  Future<void> changeRecordingVolume(String cursor, double volume) async {
    final res = await client.post('$apiUrl/sound/applications/recording/$cursor/volume/$volume');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
  }

  Future<void> togglePlaybackMute(String cursor, bool mute) async {
    final res = await client.post('$apiUrl/sound/applications/playback/$cursor/mute/$mute');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
  }

  Future<void> toggleRecordingMute(String cursor, bool mute) async {
    final res = await client.post('$apiUrl/sound/applications/recording/$cursor/mute/$mute');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
  }

  Future<void> changeOutputVolume(String cursor, double volume) async {
    final res = await client.post('$apiUrl/sound/outputs/$cursor/volume/$volume');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
  }

  Future<void> changeInputVolume(String cursor, double volume) async {
    final res = await client.post('$apiUrl/sound/inputs/$cursor/volume/$volume');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
  }

  Future<void> toggleOutputMute(String cursor, bool mute) async {
    final res = await client.post('$apiUrl/sound/outputs/$cursor/mute/$mute');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
  }

  Future<void> toggleInputMute(String cursor, bool mute) async {
    final res = await client.post('$apiUrl/sound/inputs/$cursor/mute/$mute');
    if (res.statusCode != 204) {
      throw Exception('Changing Volume failed: $res');
    }
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
