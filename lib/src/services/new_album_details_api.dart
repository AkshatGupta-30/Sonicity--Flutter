import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/services/new_artist_details_api.dart';

class NewAlbumDetailsApi {
  static Future<Map<String, dynamic>> _apiCall(String id) async {
    final uri = "https://saavn.dev/albums?id=$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<NewAlbum> get(String id) async {
    final data = await _apiCall(id);
    NewArtist artist = await NewArtistDetailsApi.getImage(data['primaryArtistsId']);
    if(data['artists'] != null) {
      data['artists'].clear();
    }
    data['artists'].add(artist.toMap());
    return NewAlbum.detail(data);
  }

  static Future<NewAlbum> getImage(String id) async {
    final data = await _apiCall(id);
    return NewAlbum.image(data);
  }
}