import 'package:sonicity/src/models/new_hot_playlists.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:sonicity/src/models/new_top_albums.dart';
import 'package:sonicity/src/models/new_top_charts.dart';
import 'package:sonicity/src/models/new_trending_now.dart';

class NewHome {
  final NewTrendingNow trendingNow;
  final NewTopCharts topCharts;
  final List<NewSong> lastSession;
  final NewTopAlbums topAlbums;
  final NewHotPlaylists hotPlaylists;

  NewHome({required this.trendingNow, required this.topCharts, required this.lastSession, required this.topAlbums, required this.hotPlaylists});

  factory NewHome.fromData({
    required NewTrendingNow trendingNow,
    required NewTopCharts topCharts,
    required List<NewSong> lastSession,
    required NewTopAlbums topAlbums,
    required NewHotPlaylists hotPlaylists
  }) {
    return NewHome(trendingNow: trendingNow, topCharts: topCharts, lastSession: lastSession, topAlbums: topAlbums, hotPlaylists: hotPlaylists);
  }

  factory NewHome.empty() {
    return NewHome(
      trendingNow: NewTrendingNow.empty(),
      topCharts: NewTopCharts.empty(),
      lastSession: [],
      topAlbums: NewTopAlbums.empty(),
      hotPlaylists: NewHotPlaylists.empty()
    );
  }
}