import 'package:sonicity/src/models/playlist.dart';

class HotPlaylists {
  final List<Playlist> playlists;

  HotPlaylists({required this.playlists});

  factory HotPlaylists.fromJson({required List<Playlist> jsonList}) {
    return HotPlaylists(playlists: jsonList);
  }

  factory HotPlaylists.empty() {
    return HotPlaylists(playlists: []);
  }
}