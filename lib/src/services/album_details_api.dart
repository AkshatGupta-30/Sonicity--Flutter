import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';

class AlbumDetailsApi {
  static Future<Album> short(String id) async {
    final uri = "https://saavn.dev/albums?id=$id";
    final response = await http.get(Uri.parse(uri));
    final data = jsonDecode(response.body)['data'];
    return Album.fromJson(data);
  }
}