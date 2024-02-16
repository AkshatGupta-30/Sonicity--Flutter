import 'dart:convert';

import 'package:sonicity/src/models/song.dart';
import 'package:http/http.dart' as http;

class SongDetailsService {
  static Future<Song> get(String id) async {
    final url = "https://saavn.dev/songs?id=$id";
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    final data = json['data'][0];

    return Song.fromJson(data);
  }
}