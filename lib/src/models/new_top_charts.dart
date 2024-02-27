import 'package:sonicity/src/models/new_playlist.dart';

class NewTopCharts {
  final List<NewPlaylist> playlists;

  NewTopCharts({required this.playlists});

  factory NewTopCharts.fromList({required List<NewPlaylist> jsonList}) {
    return NewTopCharts(playlists: jsonList);
  }

  factory NewTopCharts.empty() {
    return NewTopCharts(playlists: []);
  }
}

