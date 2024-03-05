import 'package:sonicity/src/models/hot_playlists.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/src/models/top_charts.dart';
import 'package:sonicity/src/models/trending_now.dart';

class Home {
  final TrendingNow trendingNow;
  final TopCharts topCharts;
  final TopAlbums topAlbums;
  final HotPlaylists hotPlaylists;

  Home({required this.trendingNow, required this.topCharts, required this.topAlbums, required this.hotPlaylists});

  factory Home.fromData({
    required TrendingNow trendingNow,
    required TopCharts topCharts,
    required TopAlbums topAlbums,
    required HotPlaylists hotPlaylists
  }) {
    return Home(trendingNow: trendingNow, topCharts: topCharts, topAlbums: topAlbums, hotPlaylists: hotPlaylists);
  }

  factory Home.empty() {
    return Home(
      trendingNow: TrendingNow.empty(),
      topCharts: TopCharts.empty(),
      topAlbums: TopAlbums.empty(),
      hotPlaylists: HotPlaylists.empty()
    );
  }
}