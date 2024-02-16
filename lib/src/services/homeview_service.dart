import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/song_details_service.dart';

enum HomeData {
  albums, playlists, charts, trending
}

class HomeDataService {
  HomeDataService._();

  static Future<dynamic> _retrieveData(HomeData homeData) async {
    const url = "https://saavn.dev/modules?language=hindi,english";
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    final data = json['data'];

    if(homeData == HomeData.albums) {
      return data['albums'];
    } else if(homeData == HomeData.charts) {
      return data['charts'];
    } else if(homeData == HomeData.playlists) {
      return data["playlists"];
    } else {
      return data["trending"];
    }
  }

  static Future<List<Album>> album() async {
    List<Album> albums = [];
    final data = await _retrieveData(HomeData.albums);
    for(var album in  data) {
      albums.add(Album.fromJson(album));
    }
    return albums;
  }

  static Future<List<Playlist>> playlists() async {
    List<Playlist> playlists = [];
    final data = await _retrieveData(HomeData.playlists);
    for(var playlist in data) {
      playlists.add(Playlist.fromJson(playlist));
    }
    return playlists;
  }

  static Future<void> charts() async {
    final al = [];
    final ar = [];
    final so = [];
    final pl = [];
    var data = await _retrieveData(HomeData.charts);
    for(var type in data) {
      if(type['type'] == "album") {
        al.add(type);
      } else if(type['type'] == "artist") {
        ar.add(type);
      } else if(type['type'] == "song") {
        so.add(type);
      } else if(type['type'] == "playlist") {
        pl.add(type);
      }
    }
  }

  static Future<Map> trending() async {
    var data = await _retrieveData(HomeData.trending);
    List<Song> songs = [];
    for(var song in data['songs']) {
      Song songDetais = await SongDetailsService.get(song['id']);
      songs.add(songDetais);
    }

    List<Album> albums = [];
    for(var song in data['songs']) {
      albums.add(Album.fromShortJson(song));
    }

    Map trend = {
      "songs" : songs,
      "albums" : albums
    };

    return trend;
  }
}