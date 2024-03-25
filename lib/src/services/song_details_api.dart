import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';

class SongDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/api/songs/$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Song Details Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body)['data'][0];
    return data;
  }

  static Future<List<Map<String, dynamic>>> _getArtists(List<String> artistIds) async {
    List<Map<String, dynamic>> artistForData = [];
    for(var id in artistIds) {
      Artist artist = await ArtistDetailsApi.getImage(id);
      Map<String, dynamic> artistMap = artist.toMap();
      artistForData.add(artistMap);
    }
    return artistForData;
  }

  static Future<Song> get(String id) async {
    Map<String, dynamic> data = await _apiCall(id);
    Album album = await AlbumDetailsApi.getImage(data['album']['id']);
    data['album'] = album.toMap();

    List<String> artistIds = [];
    for (var artist in data['artists']['all']) {
      artistIds.add(artist['id']);
    }
    List<Map<String, dynamic>> artistForData = await _getArtists(artistIds);
    data['artists'] = artistForData;

    return Song.detail(data);
  }

  static Future<Song> forPlay(String id) async {
    Map<String, dynamic> data = await _apiCall(id);
    List<Map<String, dynamic>> artists = [];
    for (var artist in data['artists']['all']) {
      artists.add(Artist.name(artist).toMap());
    }

    data['artists'] = artists;
    return Song.forPlay(data);
  }
}