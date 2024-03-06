import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/album_details_api.dart';
import 'package:sonicity/src/services/artist_details_api.dart';
import 'package:super_string/super_string.dart';

class SongDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/songs?id=$id";
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
    List<Map<String, String>> artist = [];
    List<String> priArtIds = data['primaryArtistsId'].toString().split(", ").toSet().toList();
    List<String> priArtNames = data['primaryArtists'].toString().split(", ").toSet().toList();
    for (int i=0; (i<priArtIds.length && i<priArtNames.length); i++) artist.add({priArtIds[i] : priArtNames[i]});

    if(data['featuredArtistsId'].toString().isNotEmpty) {
      List<String> feaArtIds = data['featuredArtistsId'].toString().split(", ").toSet().toList();
      List<String> feaArtNames = data['featuredArtists'].toString().split(", ").toSet().toList();
      for (int i=0; (i<feaArtIds.length && i<feaArtNames.length); i++) artist.add({feaArtIds[i] : feaArtNames[i]});
      priArtIds.addAll(feaArtIds);
      priArtNames.addAll(feaArtNames);
    }

    for (int i = 0; i < priArtNames.length; i++) {
      if (priArtNames[i].title().contains("And")) {
        priArtIds.removeAt(i);
        priArtNames.removeAt(i);
      }
    }

    List<Map<String, dynamic>> artists = [];
    for (int i=0; i<priArtIds.length; i++) {
      artists.add(Artist(id: priArtIds[i], name: priArtNames[i]).toMap());
    }

    data['artists'] = artists;
    return Song.forPlay(data);
  }
}