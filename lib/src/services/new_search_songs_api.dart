import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:sonicity/src/services/new_artist_details_api.dart';

class NewSearchSongsApi {
  static Future<Map> _apiCall(String text, int page, int limit) async {
    final uri = "https://saavn.dev/search/songs?query=$text&page=$page&limit=10";
    final response = await http.get(Uri.parse(uri));
    final data = jsonDecode(response.body);
    return data;
  }

  static Future<List<Map<String, dynamic>>> _getArtists(List<String> artistIds) async {
    List<Map<String, dynamic>> artistForData = [];
    for(var id in artistIds) {
      NewArtist artist = await NewArtistDetailsApi.getName(id);
      Map<String, dynamic> artistMap = artist.toMap();
      artistForData.add(artistMap);
    }
    return artistForData;
  }

  static Future<List<NewSong>> fetchData(String text, int page) async {
    Map result = await _apiCall(text, page, 10);
    if(result['data'] == null) {
      return [];
    }
    List<NewSong> songs = [];
    for (var element in result['data']['results']) {
      String allArtistId = "${element['primaryArtistsId']}";
      if(element['featuredArtistsId'].toString().isNotEmpty) {
        allArtistId += ", ${element['featuredArtistsId']}";
      }
      List<String> artistIds = allArtistId.split(", ").toList().toSet().toList();
      List<Map<String, dynamic>> artistForData = await _getArtists(artistIds);
      element['artists'] = artistForData;
      songs.add(NewSong.detail(element));
    }
    return songs;
  }

  static Future<int> fetchCount(String text) async {
    Map result = await _apiCall(text, 0, 1);
    return int.parse(result['data']['total'].toString());
  }
}

//await NewArtistDetailsApi.getImage()