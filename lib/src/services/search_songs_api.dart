import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/song.dart';

class SearchSongsApi {
  static Future<Map> _apiCall(String text, int page) async {
    final uri = "https://saavn.dev/search/songs?query=$text&page=$page&limit=10";
    final response = await http.get(Uri.parse(uri));
    final data = jsonDecode(response.body);
    return data;
  }

  static Future<List<Song>> fetchData(String text, int page) async {
    Map result = await _apiCall(text, page);
    if(result['data'] == null) {
      return [];
    }
    List<Song> songs = [];
    for (var element in result['data']['results']) {
      songs.add(Song.fromJson(element));
    }
    return songs;
  }
}