import 'package:sonicity/src/models/playlist.dart';

class TopCharts {
  final List<Playlist> playlists;

  TopCharts({required this.playlists});

  factory TopCharts.fromList({required List<Playlist> jsonList}) {
    return TopCharts(playlists: jsonList);
  }

  factory TopCharts.empty() {
    return TopCharts(playlists: []);
  }

  void clear() {
    playlists.clear();
  }
}

