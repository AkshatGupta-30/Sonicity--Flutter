import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/artist_song_album.dart';
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

  static Future<Map<String, dynamic>> _albumsApiCall(String id, int page, Category category, Sort sort) async {
    String cat = (category == Category.alphabetical) ? "alphabetical" : "latest";
    String sortBy = (sort == Sort.asc) ? "asc" : "desc";
    final uri = "https://saavn.dev/artists/$id/albums?page=$page&category=$cat&sort=$sortBy";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Map<String, dynamic>> _songsApiCall(String id, int page, Category category, Sort sort) async {
    String cat = (category == Category.alphabetical) ? "alphabetical" : "latest";
    String sortBy = (sort == Sort.asc) ? "asc" : "desc";
    final uri = "https://saavn.dev/artists/$id/songs?page=$page&category=$cat&sort=$sortBy";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<List<Album>> getAlbums(String id, int page, Category category, Sort sort) async {
    final data = await _albumsApiCall(id, page, category, sort);
    if(data['results'] == null) {
      return [];
    }
    List<Album> albums = [];
    for (var element in data['results']) {
      albums.add(Album.songCount(element));
    }
    return albums;
  }

  static Future<int> getAlbumCount(String id) async {
    final data = await _albumsApiCall(id, 1, Category.alphabetical, Sort.asc);
    if(data['results'] == null) {
      return 0;
    }
    return int.parse(data['total'].toString());
  }

  static Future<List<Song>> getSongs(String id, int page, Category category, Sort sort) async {
    final data = await _songsApiCall(id, page, category, sort);
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
    final data = await _songsApiCall(id,  1, Category.alphabetical, Sort.asc);
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