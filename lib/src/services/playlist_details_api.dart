import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/playlist.dart';

class PlaylistDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/playlists?id=$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Playlist> get(String id) async {
    Map<String, dynamic> data = await _apiCall(id);

    return Playlist.detail(data);
  }
}