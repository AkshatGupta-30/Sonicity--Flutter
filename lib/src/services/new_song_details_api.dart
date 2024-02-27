import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:sonicity/src/services/new_album_details_api.dart';
import 'package:sonicity/src/services/new_artist_details_api.dart';

class NewSongDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/songs?id=$id";
    final response = await http.get(Uri.parse(uri));
    final data = jsonDecode(response.body)['data'][0];
    return data;
  }

  static Future<List<Map<String, dynamic>>> _getArtists(List<String> artistIds) async {
    List<Map<String, dynamic>> artistForData = [];
    for(var id in artistIds) {
      NewArtist artist = await NewArtistDetailsApi.getImage(id);
      Map<String, dynamic> artistMap = artist.toMap();
      artistForData.add(artistMap);
    }
    return artistForData;
  }

  static Future<NewSong> get(String id) async {
    Map<String, dynamic> data = await _apiCall(id);
    NewAlbum album = await NewAlbumDetailsApi.getImage(data['album']['id']);
    data['album'] = album.toMap();

    String allArtistId = "${data['primaryArtistsId']}";
    if(data['featuredArtistsId'].toString().isNotEmpty) {
      allArtistId += ", ${data['featuredArtistsId']}";
    }
    List<String> artistIds = allArtistId.split(", ").toList().toSet().toList();
    List<Map<String, dynamic>> artistForData = await _getArtists(artistIds);
    data['artists'] = artistForData;

    return NewSong.detail(data);
  }

  static Future<NewSong> forPlay(String id) async {
    Map<String, dynamic> data = await _apiCall(id);
    String allArtistId = "${data['primaryArtistsId']}";
    if(data['featuredArtistsId'].toString().isNotEmpty) {
      allArtistId += ", ${data['featuredArtistsId']}";
    }
    List<String> artistIds = allArtistId.split(", ").toList().toSet().toList();
    List<Map<String, dynamic>> artistForData = await _getArtists(artistIds);
    data['artists'] = artistForData;

    return NewSong.detail(data);
  }
}