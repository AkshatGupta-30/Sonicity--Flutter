import 'package:get/get.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/test_service.dart';

class TrendingNow {
  final List<Song> songs;
  final List<Album> albums;

  TrendingNow({required this.songs, required this.albums});

  factory TrendingNow.fromList({required List<Map<String, dynamic>> al, required List<Map<String, dynamic>> so}) {
    List<Album> albums = [];
    List<Song> songs = [];
    for (var album in al) {
      albums.add(Album.fromShortJson(album));
    }
    for (var song in so) {
      songs.add(Song.fromJson(song));
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

class HomeViewApi extends GetxController {
  final trendingNowList = TrendingNow.fromList(al: TestApi().albumList, so: TestApi().songsList).obs;
  final topCharts = TopCharts.fromJson(jsonList: TestApi().topCharts).obs;
}