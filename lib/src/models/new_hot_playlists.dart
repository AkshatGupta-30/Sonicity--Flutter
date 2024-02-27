import 'package:sonicity/src/models/new_playlist.dart';

class NewHotPlaylists {
  final List<NewPlaylist> playlists;

  NewHotPlaylists({required this.playlists});

  factory NewHotPlaylists.fromJson({required List<NewPlaylist> jsonList}) {
    return NewHotPlaylists(playlists: jsonList);
  }

  factory NewHotPlaylists.empty() {
    return NewHotPlaylists(playlists: []);
  }
}