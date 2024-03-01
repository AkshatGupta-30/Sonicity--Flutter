import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';

class ArtistDetailsApi {
  static Future<Map<String, dynamic>> _detailsApiCall(String id) async {
    final uri = "https://saavn.dev/artists?id=$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Map<String, dynamic>> _albumsApiCall(String id, int page) async {
    final uri = "https://saavn.dev/artists/$id/albums?page=$page";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Map<String, dynamic>> _songsApiCall(String id, int page) async {
    final uri = "https://saavn.dev/artists/$id/songs?page=$page";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<List<Album>> getAlbums(String id, int page) async {
    final data = await _albumsApiCall(id, page);
    if(data['results'] == null) {
      return [];
    }
    List<Album> albums = [];
    for (var element in data['results']) {
      albums.add(Album.year(element));
    }
    return albums;
  }

  static Future<int> getAlbumCount(String id) async {
    final data = await _albumsApiCall(id, 1);
    if(data['results'] == null) {
      return 0;
    }
    return int.parse(data['total'].toString());
  }

  static Future<List<Song>> getSongs(String id, int page) async {
    final data = await _songsApiCall(id, page);
    if(data['results'] == null) {
      return [];
    }
    List<Song> songs = [];
    for (var element in data['results']) {
      songs.add(Song.forPlay(element));
    }
    return songs;
  }

  static Future<int> getSongCount(String id) async {
    final data = await _songsApiCall(id,  1);
    if(data['results'] == null) {
      return 0;
    }
    return int.parse(data['total'].toString());
  }

  static Future<Artist> get(String id) async {
    final data = await _detailsApiCall(id);
    return Artist.detail(data);
  }

  static Future<Artist> getImage(String id) async {
    final data = await _detailsApiCall(id);
    return Artist.image(data);
  }

  static Future<Artist> getName(String id) async {
    final data = await _detailsApiCall(id);
    return Artist.name(data);
  }
}