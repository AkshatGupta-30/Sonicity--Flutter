import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/playlist.dart';

class PlaylistDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/api/playlists?id=$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Playlist Details Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Playlist> get(String id) async {
    final data = await _apiCall(id);
    return Playlist.detail(data);
  }
}