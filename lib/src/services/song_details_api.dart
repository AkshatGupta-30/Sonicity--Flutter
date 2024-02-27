import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/album_details_api.dart';
import 'package:sonicity/src/services/artist_details_api.dart';

class SongDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/songs?id=$id";
    final response = await http.get(Uri.parse(uri));
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

    String allArtistId = "${data['primaryArtistsId']}";
    if(data['featuredArtistsId'].toString().isNotEmpty) {
      allArtistId += ", ${data['featuredArtistsId']}";
    }
    List<String> artistIds = allArtistId.split(", ").toList().toSet().toList();
    List<Map<String, dynamic>> artistForData = await _getArtists(artistIds);
    data['artists'] = artistForData;

    return Song.detail(data);
  }

  static Future<Song> forPlay(String id) async {
    Map<String, dynamic> data = await _apiCall(id);
    String allArtistId = "${data['primaryArtistsId']}";
    if(data['featuredArtistsId'].toString().isNotEmpty) {
      allArtistId += ", ${data['featuredArtistsId']}";
    }
    List<String> artistIds = allArtistId.split(", ").toList().toSet().toList();
    List<Map<String, dynamic>> artistForData = await _getArtists(artistIds);
    data['artists'] = artistForData;

    return Song.detail(data);
  }
}