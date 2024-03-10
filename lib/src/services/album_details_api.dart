import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/services/artist_details_api.dart';

class AlbumDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/api/albums?id=$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Album Details Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Album> get(String id) async {
    final data = await _apiCall(id);
    List<String> artistIds = data['primaryArtistsId'].toString().split(", ").toList();
    List<Map<String,dynamic>> artistMap = [];
    for(var id in artistIds) {
      Artist artist = await ArtistDetailsApi.getImage(id);
      artistMap.add(artist.toMap());
    }
    data['artists'] = artistMap;
    return Album.detail(data);
  }

  static Future<Album> getImage(String id) async {
    final data = await _apiCall(id);
    return Album.image(data);
  }
}