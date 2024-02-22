import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/playlist.dart';

class PlaylistDetailsApi {
  static Future<Playlist> short(String id) async {
    final uri = "https://saavn.dev/playlists?id=$id";
    final response = await http.get(Uri.parse(uri));
    final data = jsonDecode(response.body)['data'];
    return Playlist.fromJson(data);
  }
}