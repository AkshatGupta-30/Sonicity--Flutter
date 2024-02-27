import 'dart:convert';

import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_home.dart';
import 'package:sonicity/src/models/new_hot_playlists.dart';
import 'package:sonicity/src/models/new_playlist.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:sonicity/src/models/new_top_albums.dart';
import 'package:sonicity/src/models/new_top_charts.dart';
import 'package:sonicity/src/models/new_trending_now.dart';
import 'package:sonicity/src/services/new_song_details_api.dart';
import 'package:sonicity/src/sprefs/last_session_sprefs.dart';
import 'package:http/http.dart' as http;

class NewHomeViewApi {
  static Future<Map<String, dynamic>> _apiCall() async {
    const uri = "https://saavn.dev/modules?language=hindi,english";
    final response = await http.get(Uri.parse(uri));
    final json = jsonDecode(response.body);
    return json['data'];
  }

  static Future<NewTrendingNow> _getTrendingData(Map<String, dynamic> data) async {
    final List<NewSong> trendingSongsList = [];
    final List<NewAlbum> trendingAlbumsList = [];

    for (var song in data['songs']) {
      NewSong songDetail = await NewSongDetailsApi.get(song['id'].toString());
      trendingSongsList.add(songDetail);
    }

    for (var album in data['albums']) {
      NewAlbum albumDetail = NewAlbum.songCount(album);
      trendingAlbumsList.add(albumDetail);
    }
    return NewTrendingNow.fromList(albums: trendingAlbumsList, songs: trendingSongsList);
  }

  static Future<NewTopCharts> _getTopCharts(List<dynamic> data) async {
    final List<NewPlaylist> playlistList = [];

    for (var chart in data) {
      if(chart['type'] == 'playlist') {
        NewPlaylist playlistDetail = NewPlaylist.language(chart);
        playlistList.add(playlistDetail);
      }
    }
    return NewTopCharts.fromList(jsonList: playlistList);
  }

  static Future<NewTopAlbums> _getTopAlbums(List<dynamic> data) async {
    final List<NewAlbum> albums = [];

    for(var album in data) {
      albums.add(NewAlbum.language(album));
    }
    return NewTopAlbums.fromJson(jsonList: albums);
  }

  static Future<NewHotPlaylists> _getHotPlaylists(List<dynamic> data) async {
    final List<NewPlaylist> playlists = [];

    for(var playlist in data) {
      playlists.add(NewPlaylist.detail(playlist));
    }
    return NewHotPlaylists.fromJson(jsonList: playlists);
  }

  static Future<List<NewSong>> _getLastSession() async {
    List<String> loadedSongs = await LastSessionSprefs.load();
    List<NewSong> songs = [];
    for (var id in loadedSongs) {
      NewSong song = await NewSongDetailsApi.get(id);
      songs.insert(0, song);
    }
    return songs;
  }

  static Future<NewHome> get() async {
    final json = await _apiCall();
    NewTrendingNow trendingNow = await _getTrendingData(json['trending']);
    NewTopCharts topCharts = await _getTopCharts(json['charts']);
    List<NewSong> lastSession = await _getLastSession();
    NewTopAlbums topAlbums = await _getTopAlbums(json['albums']);
    NewHotPlaylists hotPlaylists = await _getHotPlaylists(json['playlists']);

    return NewHome.fromData(trendingNow: trendingNow, topCharts: topCharts, lastSession: lastSession, topAlbums: topAlbums, hotPlaylists: hotPlaylists);
  }
}