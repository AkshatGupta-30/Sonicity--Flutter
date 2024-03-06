import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';

class SearchSongsApi {
  static Future<Map> _apiCall(String text, int page, int limit) async {
    final uri = "https://saavn.dev/search/songs?query=$text&page=$page&limit=10";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Search Songs Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)}".printError();
      return {};
    }
    final data = jsonDecode(response.body);
    return data;
  }

  static List<Map<String, dynamic>> _getArtists(String primaryId, String primaryName, String featureId, String featureName) {
    List<Map<String, dynamic>> artistForData = [];
    String allArtistIds = primaryId;
    String allArtists = primaryName;
    if(featureId.isNotEmpty) {
      allArtistIds += ", $featureId";
    }
    if(featureName.isNotEmpty) {
      allArtistIds += ", $featureName";
    }
    List<String> artistIds = allArtistIds.split(", ").toList().toSet().toList();
    List<String> artists = allArtists.split(", ").toList().toSet().toList();
    for(int i = 0; i<artistIds.length; i++) {
      if(i == artistIds.length || i == artists.length) {
        break;
      }
      Artist artist = Artist.name({
        "id" : artistIds[i],
        "name" : artists[i]
      });
      Map<String, dynamic> artistMap = artist.toMap();
      artistForData.add(artistMap);
    }
    return artistForData;
  }

  static Future<List<Song>> fetchData(String text, int page) async {
    Map result = await _apiCall(text, page, 5);
    if(result['data'] == null) {
      return [];
    }
    List<Song> songs = [];
    for (var element in result['data']['results']) {
      List<Map<String, dynamic>> artistForData = _getArtists(
        element['primaryArtistsId'], element['primaryArtists'],
        element['featuredArtistsId'].toString(), element['featuredArtists'].toString()
      );
      element['artists'] = artistForData;
      songs.add(Song.forPlay(element));
    }
    return songs;
  }

  static Future<int> fetchCount(String text) async {
    Map result = await _apiCall(text, 0, 1);
    return int.parse(result['data']['total'].toString());
  }
}