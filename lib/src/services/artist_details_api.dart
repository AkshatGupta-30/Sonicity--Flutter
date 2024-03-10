import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';

class ArtistDetailsApi {
  static Future<Map<String, dynamic>> _detailsApiCall(String id) async {
    final uri = "https://saavn.dev/api/artists/$id";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Artist Details Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Map<String, dynamic>> _albumsApiCall(String id, int page) async {
    final uri = "https://saavn.dev/api/artists/$id/albums?page=$page";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Albums Details Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<Map<String, dynamic>> _songsApiCall(String id, int page) async {
    final uri = "https://saavn.dev/api/artists/$id/songs?page=$page";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Songs Details Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  static Future<List<Album>> getAlbums(String id, int page) async {
    final data = await _albumsApiCall(id, page);
    List<Album> albums = [];
    for (var element in data['albums']) {
      albums.add(Album.year(element));
    }
    return albums;
  }

  static Future<int> getAlbumCount(String id) async {
    final data = await _albumsApiCall(id, 1);
    return int.parse(data['total'].toString());
  }

  static Future<List<Song>> getSongs(String id, int page) async {
    final data = await _songsApiCall(id, page);
    List<Song> songs = [];
    for (var song in data['songs']) {
      List<Map<String, dynamic>> artists = [];
      for (var artist in song['artists']['all']) {
        artists.add(Artist.name(artist).toMap());
      }
      song['artists'] = artists;
      songs.add(Song.forPlay(song));
    }
    return songs;
  }

  static Future<int> getSongCount(String id) async {
    final data = await _songsApiCall(id,  1);
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