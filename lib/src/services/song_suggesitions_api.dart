import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';

class SongSuggestionsApi {
  static Future<Map> _apiCall(String id, int limit) async {
    final uri = "https://saavn.dev/api/songs/$id/suggestions?limit=$limit";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Search Playlist Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body);
    return data;
  }

  static Future<List<Song>> fetchData(String id) async {
    Map result = await _apiCall(id, Get.find<SettingsController>().getSuggestionMaxLength);
    if(result['data'] == null) {
      return [];
    }
    List<Song> songs = [];
    for (var songMap in result['data']) {
      List<Map<String, dynamic>> artists = [];
      for (var artist in songMap['artists']['all']) {
        artists.add(Artist.name(artist).toMap());
      }

      songMap['artists'] = artists;
      songs.add(Song.forPlay(songMap));
    }
    return songs;
  }
}