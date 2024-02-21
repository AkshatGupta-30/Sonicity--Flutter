import 'dart:convert';

import 'package:get/get.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/song_details_api.dart';
import 'package:sonicity/src/services/test_service.dart';
import 'package:sonicity/src/sprefs/last_session_sprefs.dart';
import 'package:http/http.dart' as http;

class TrendingNow {
  final List<Song> songs;
  final List<Album> albums;

  TrendingNow({required this.songs, required this.albums});

  factory TrendingNow.fromList({required List<Album> albums, required List<Song> songs}) {
    return TrendingNow(
      albums: albums,
      songs: songs
    );
  }
}

class TopCharts {
  final List<Playlist> playlists;

  TopCharts({required this.playlists});

  factory TopCharts.fromList({required List<Playlist> jsonList}) {
    return TopCharts(playlists: jsonList);
  }
}

class HotPlaylists {
  final List<Playlist> playlists;

  HotPlaylists({required this.playlists});

  factory HotPlaylists.fromJson({required List<Map<String, dynamic>> jsonList}) {
    List<Playlist> playlists = [];
    for (var playlist in jsonList) {
      playlists.add(Playlist.fromJson(playlist));
    }
    return HotPlaylists(playlists: playlists);
  }
}

class TopAlbums {
  final List<Album> albums;
  TopAlbums({required this.albums});

  factory TopAlbums.fromJson({required List<Map<String, dynamic>> jsonList}) {
    List<Album> albums = [];
    for (var json in jsonList) {
      if(json['type'] == 'album') {
        albums.add(Album.fromShortJson(json));
      }
    }
    return TopAlbums(albums: albums);
  }
}

class HomeViewApi extends GetxController {
  final trendingNowList = TrendingNow.fromList(albums: [], songs: []).obs;
  final topCharts = TopCharts.fromList(jsonList: []).obs;
  final lastSessionSprefs = <String>[].obs;
  final lastSessionSongs = <Song>[].obs;
  final topAlbums = TopAlbums.fromJson(jsonList: TestApi().topAlbums).obs;
  final hotPlaylist = HotPlaylists.fromJson(jsonList: TestApi().playlistList).obs;

  @override
  void onReady() {
    getHomeData();
    getLastSession();
    super.onReady();
  }

  void getHomeData() async {
    const uri = "https://saavn.dev/modules?language=hindi,english";
    final response = await http.get(Uri.parse(uri));
    final json = jsonDecode(response.body);

    getTrendingData(json['data']['trending']);
    getTopCharts(json['data']['charts']);
  }

  void getTrendingData(Map<String, dynamic> data) async {
    final List<Song> trendingSongsList = [];
    final List<Album> trendingAlbumsList = [];

    for (var song in data['songs']) {
      Song songDetail = await SongDetailsApi.short(song['id'].toString());
      trendingSongsList.add(songDetail);
    }

    for (var album in data['albums']) {
      Album albumDetail = Album.fromShortJson(album);
      trendingAlbumsList.add(albumDetail);
    }
    trendingNowList.value = TrendingNow.fromList(albums: trendingAlbumsList, songs: trendingSongsList);
  }

  void getTopCharts(List<dynamic> data) async {
    final List<Playlist> playlistList = [];

    for (var chart in data) {
      if(chart['type'] == 'playlist') {
        Playlist playlistDetail = Playlist.fromJson(chart);
        playlistList.add(playlistDetail);
      }
    }
    topCharts.value = TopCharts.fromList(jsonList: playlistList);
  }

  void getLastSession() async {
    List<String> loadedSongs = await LastSessionSprefs.load();
    lastSessionSprefs.assignAll(loadedSongs);
    update();
    for (var id in lastSessionSprefs) {
      final uri = "https://saavn.dev/songs?id=$id";
      final response = await http.get(Uri.parse(uri));
      final json = jsonDecode(response.body);
      lastSessionSongs.insert(0, Song.fromJson(json['data'][0]));
      update();
    }
  }
}