import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/models.dart';

class LyricsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/api/songs/$id/lyrics";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Lyrics Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Lyrics> fetch(Song song) async {
    if(!song.hasLyrics) {
      return Lyrics.empty();
    }
    final data = await _apiCall(song.id);
    return Lyrics.details(data);
  }
}