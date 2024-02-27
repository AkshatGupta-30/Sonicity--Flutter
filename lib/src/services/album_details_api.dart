import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/services/artist_details_api.dart';

class AlbumDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/albums?id=$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Album> get(String id) async {
    final data = await _apiCall(id);
    Artist artist = await ArtistDetailsApi.getImage(data['primaryArtistsId']);
    if(data['artists'] != null) {
      data['artists'].clear();
    }
    data['artists'].add(artist.toMap());
    return Album.detail(data);
  }

  static Future<Album> getImage(String id) async {
    final data = await _apiCall(id);
    return Album.image(data);
  }
}