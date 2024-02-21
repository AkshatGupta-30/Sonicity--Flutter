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

  factory TrendingNow.fromList({required List<Map<String, dynamic>> al, required List<Song> songs}) {
    List<Album> albums = [];
    for (var album in al) {
      albums.add(Album.fromShortJson(album));
    }
    return TrendingNow(
      albums: albums,
      songs: songs
    );
  }
}

class TopCharts {
  final List<Playlist> playlists;

  TopCharts({required this.playlists});

  factory TopCharts.fromJson({required List<Map<String, dynamic>> jsonList}) {
    List<Playlist> playlists = [];
    for (var chart in jsonList) {
      if(chart['type'] == 'playlist') {
        playlists.add(Playlist.fromJson(chart));
      }
    }
    return TopCharts(playlists: playlists);
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
  final trendingNowList = TrendingNow.fromList(al: TestApi().albumList, songs: []).obs;
  final topCharts = TopCharts.fromJson(jsonList: TestApi().topCharts).obs;
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
  }

  void getTrendingData(Map<String, dynamic> data) async {
    final List<Song> trendingSongsList = [];
    for (var song in data['songs']) {
      Song songDetail = await SongDetailsApi.short(song['id'].toString());
      trendingSongsList.add(songDetail);
    }
    trendingNowList.value = TrendingNow.fromList(al: [], songs: trendingSongsList);
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