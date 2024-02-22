import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/artist.dart';

class ArtistDetailsApi {
  static Future<Artist> short(String id) async {
    final uri = "https://saavn.dev/artists?id=$id";
    final response = await http.get(Uri.parse(uri));
    final json = jsonDecode(response.body);
    return Artist.fromShortJson(json['data']);
  }
}