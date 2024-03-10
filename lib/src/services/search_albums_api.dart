import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';

class SearchAlbumsApi {
  static Future<Map> _apiCall(String text, int page, int limit) async {
    final uri = "https://saavn.dev/api/search/albums?query=$text&page=$page&limit=$limit";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Search Albums Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body);
    return data;
  }

  static Future<List<Album>> fetchData(String text, int page) async {
    Map result = await _apiCall(text, page, 10);
    if(result['data'] == null) {
      return [];
    }
    List<Album> albums = [];
    for (var album in result['data']['results']) {
      albums.add(Album.songCount(album));
    }
    return albums;
  }

  static Future<int> fetchCount(String text) async {
    Map result = await _apiCall(text, 0, 1);
    return int.parse(result['data']['total'].toString());
  }
}