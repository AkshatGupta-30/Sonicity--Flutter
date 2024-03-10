import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';

class SearchSongsApi {
  static Future<Map> _apiCall(String text, int page, int limit) async {
    final uri = "https://saavn.dev/api/search/songs?query=$text&page=$page&limit=10";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Search Songs Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)}".printError();
      return {};
    }
    final data = jsonDecode(response.body);
    return data;
  }

  static Future<List<Song>> fetchData(String text, int page) async {
    Map result = await _apiCall(text, page, 5);
    if(result['data'] == null) {
      return [];
    }
    List<Song> songs = [];
    for (var song in result['data']['results']) {
      List<Map<String, dynamic>> artists = [];
      for (var artist in song['artists']['all']) {
        artists.add(Artist.name(artist).toMap());
      }
      song['artists'] = artists;
      songs.add(Song.forPlay(song));
    }
    return songs;
  }

  static Future<int> fetchCount(String text) async {
    Map result = await _apiCall(text, 0, 1);
    return int.parse(result['data']['total'].toString());
  }
}