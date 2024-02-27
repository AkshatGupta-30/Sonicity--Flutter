import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/new_playlist.dart';

class NewPlaylistDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/playlists?id=$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<NewPlaylist> get(String id) async {
    Map<String, dynamic> data = await _apiCall(id);

    return NewPlaylist.detail(data);
  }
}