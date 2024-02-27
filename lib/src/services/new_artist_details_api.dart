import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/models/new_artist_song_album.dart';
import 'package:sonicity/src/models/new_song.dart';

class NewArtistDetailsApi {
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

  static Future<List<NewAlbum>> getAlbums(String id, int page, Category category, Sort sort) async {
    final data = await _albumsApiCall(id, page, category, sort);
    if(data['results'] == null) {
      return [];
    }
    List<NewAlbum> albums = [];
    for (var element in data['results']) {
      albums.add(NewAlbum.image(element));
    }
    return albums;
  }

  static Future<int> getAlbumCount(String id, int page, Category category, Sort sort) async {
    final data = await _albumsApiCall(id, page, category, sort);
    if(data['results'] == null) {
      return 0;
    }
    return int.parse(data['total'].toString());
  }

  static Future<List<NewSong>> getSongs(String id, int page, Category category, Sort sort) async {
    final data = await _songsApiCall(id, page, category, sort);
    if(data['results'] == null) {
      return [];
    }
    List<NewSong> songs = [];
    for (var element in data['results']) {
      songs.add(NewSong.detail(element));
    }
    return songs;
  }

  static Future<int> getSongCount(String id, int page, Category category, Sort sort) async {
    final data = await _songsApiCall(id, page, category, sort);
    if(data['results'] == null) {
      return 0;
    }
    return int.parse(data['total'].toString());
  }

  static Future<NewArtist> get(String id) async {
    final data = await _detailsApiCall(id);
    return NewArtist.detail(data);
  }

  static Future<NewArtist> getImage(String id) async {
    final data = await _detailsApiCall(id);
    return NewArtist.image(data);
  }

  static Future<NewArtist> getName(String id) async {
    final data = await _detailsApiCall(id);
    return NewArtist.name(data);
  }
}