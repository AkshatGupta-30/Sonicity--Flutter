import 'package:sonicity/src/models/models.dart';

class HotPlaylists {
  final List<Playlist> playlists;

  HotPlaylists({required this.playlists});

  factory HotPlaylists.fromJson({required List<Playlist> jsonList}) {
    return HotPlaylists(playlists: jsonList);
  }

  factory HotPlaylists.empty() {
    return HotPlaylists(playlists: []);
  }

  void clear() {
    playlists.clear();
  }
}