import 'dart:convert';

import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/home.dart';
import 'package:sonicity/src/models/hot_playlists.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/src/models/top_charts.dart';
import 'package:sonicity/src/models/trending_now.dart';
import 'package:sonicity/src/services/song_details_api.dart';
import 'package:sonicity/src/sprefs/last_session_sprefs.dart';
import 'package:http/http.dart' as http;

class HomeViewApi {
  static Future<Map<String, dynamic>> _apiCall() async {
    const uri = "https://saavn.dev/modules?language=hindi,english";
    final response = await http.get(Uri.parse(uri));
    final json = jsonDecode(response.body);
    return json['data'];
  }

  static Future<TrendingNow> _getTrendingData(Map<String, dynamic> data) async {
    final List<Song> trendingSongsList = [];
    final List<Album> trendingAlbumsList = [];

    for (var song in data['songs']) {
      Song songDetail = await SongDetailsApi.get(song['id'].toString());
      trendingSongsList.add(songDetail);
    }

    for (var album in data['albums']) {
      Album albumDetail = Album.fromShortJson(album);
      trendingAlbumsList.add(albumDetail);
    }
    return TrendingNow.fromList(albums: trendingAlbumsList, songs: trendingSongsList);
  }

  static Future<TopCharts> _getTopCharts(List<dynamic> data) async {
    final List<Playlist> playlistList = [];

    for (var chart in data) {
      if(chart['type'] == 'playlist') {
        Playlist playlistDetail = Playlist.fromJson(chart);
        playlistList.add(playlistDetail);
      }
    }
    return TopCharts.fromList(jsonList: playlistList);
  }

  static Future<TopAlbums> _getTopAlbums(List<dynamic> data) async {
    final List<Album> albums = [];

    for(var album in data) {
      albums.add(Album.fromShortJson(album));
    }
    return TopAlbums.fromJson(jsonList: albums);
  }

  static Future<HotPlaylists> _getHotPlaylists(List<dynamic> data) async {
    final List<Playlist> playlists = [];

    for(var playlist in data) {
      playlists.add(Playlist.fromJson(playlist));
    }
    return HotPlaylists.fromJson(jsonList: playlists);
  }

  static Future<List<Song>> _getLastSession() async {
    List<String> loadedSongs = await LastSessionSprefs.load();
    List<Song> songs = [];
    for (var id in loadedSongs) {
      final uri = "https://saavn.dev/songs?id=$id";
      final response = await http.get(Uri.parse(uri));
      final json = jsonDecode(response.body);
      songs.insert(0, Song.fromJson(json['data'][0]));
    }
    return songs;
  }

  static Future<Home> get() async {
    final json = await _apiCall();
    TrendingNow trendingNow = await _getTrendingData(json['trending']);
    TopCharts topCharts = await _getTopCharts(json['charts']);
    List<Song> lastSession = await _getLastSession();
    TopAlbums topAlbums = await _getTopAlbums(json['albums']);
    HotPlaylists hotPlaylists = await _getHotPlaylists(json['playlists']);

    return Home.fromData(trendingNow: trendingNow, topCharts: topCharts, lastSession: lastSession, topAlbums: topAlbums, hotPlaylists: hotPlaylists);
  }
}