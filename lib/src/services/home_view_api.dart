import 'dart:convert';

import 'package:get/get.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/hot_playlists.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/src/models/top_charts.dart';
import 'package:sonicity/src/models/trending_now.dart';
import 'package:sonicity/src/services/song_details_api.dart';
import 'package:http/http.dart' as http;

class HomeViewApi {
  static Future<Map<String, dynamic>> _apiCall() async {
    final uri = "https://saavn.dev/modules?language=${Get.find<SettingsController>().getMusicLang}";
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode != 200) {
      "Home View Api\nStatus Code : ${response.statusCode}\nMessage : ${jsonDecode(response.body)['message']}".printError();
      return {};
    }
    final json = jsonDecode(response.body);
    return json['data'];
  }

  static Future<TrendingNow> _getTrendingData(Map<String, dynamic> data) async {
    final List<Song> trendingSongsList = [];
    final List<Album> trendingAlbumsList = [];

    for (var song in data['songs']) {
      Song songDetail = await SongDetailsApi.forPlay(song['id'].toString());
      trendingSongsList.add(songDetail);
    }

    for (var album in data['albums']) {
      Album albumDetail = Album.songCount(album);
      trendingAlbumsList.add(albumDetail);
    }
    return TrendingNow.fromList(albums: trendingAlbumsList, songs: trendingSongsList);
  }

  static Future<TopCharts> _getTopCharts(List<dynamic> data) async {
    final List<Playlist> playlistList = [];

    for (var chart in data) {
      if(chart['type'] == 'playlist') {
        Playlist playlistDetail = Playlist.language(chart);
        playlistList.add(playlistDetail);
      }
    }
    return TopCharts.fromList(jsonList: playlistList);
  }

  static Future<TopAlbums> _getTopAlbums(List<dynamic> data) async {
    final List<Album> albums = [];

    for(var album in data) {
      albums.add(Album.language(album));
    }
    return TopAlbums.fromJson(jsonList: albums);
  }

  static Future<HotPlaylists> _getHotPlaylists(List<dynamic> data) async {
    final List<Playlist> playlists = [];

    for(var playlist in data) {
      playlists.add(Playlist.detail(playlist));
    }
    return HotPlaylists.fromJson(jsonList: playlists);
  }

  static Future<(TrendingNow, TopCharts, TopAlbums, HotPlaylists)> get() async {
    final json = await _apiCall();
    TrendingNow trendingNow = await _getTrendingData(json['trending']);
    TopCharts topCharts = await _getTopCharts(json['charts']);
    TopAlbums topAlbums = await _getTopAlbums(json['albums']);
    HotPlaylists hotPlaylists = await _getHotPlaylists(json['playlists']);

    return (trendingNow, topCharts, topAlbums, hotPlaylists);
  }
}