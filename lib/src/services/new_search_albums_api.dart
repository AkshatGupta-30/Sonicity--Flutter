import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/new_album.dart';

class NewSearchAlbumsApi {
  static Future<Map> _apiCall(String text, int page, int limit) async {
    final uri = "https://saavn.dev/search/albums?query=$text&page=$page&limit=$limit";
    final response = await http.get(Uri.parse(uri));
    final data = jsonDecode(response.body);
    return data;
  }

  static Future<List<NewAlbum>> fetchData(String text, int page) async {
    Map result = await _apiCall(text, page, 10);
    if(result['data'] == null) {
      return [];
    }
    List<NewAlbum> albums = [];
    for (var element in result['data']['results']) {
      albums.add(NewAlbum.songCount(element));
    }
    return albums;
  }

  static Future<int> fetchCount(String text) async {
    Map result = await _apiCall(text, 0, 1);
    return int.parse(result['data']['total'].toString());
  }
}