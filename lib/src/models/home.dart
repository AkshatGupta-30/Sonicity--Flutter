import 'package:sonicity/src/models/hot_playlists.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/src/models/top_charts.dart';
import 'package:sonicity/src/models/trending_now.dart';

class Home {
  final TrendingNow trendingNow;
  final TopCharts topCharts;
  final List<Song> lastSession;
  final TopAlbums topAlbums;
  final HotPlaylists hotPlaylists;

  Home({required this.trendingNow, required this.topCharts, required this.lastSession, required this.topAlbums, required this.hotPlaylists});

  factory Home.fromData({
    required TrendingNow trendingNow,
    required TopCharts topCharts,
    required List<Song> lastSession,
    required TopAlbums topAlbums,
    required HotPlaylists hotPlaylists
  }) {
    return Home(trendingNow: trendingNow, topCharts: topCharts, lastSession: lastSession, topAlbums: topAlbums, hotPlaylists: hotPlaylists);
  }

  factory Home.empty() {
    return Home(
      trendingNow: TrendingNow.empty(),
      topCharts: TopCharts.empty(),
      lastSession: [],
      topAlbums: TopAlbums.empty(),
      hotPlaylists: HotPlaylists.empty()
    );
  }
}