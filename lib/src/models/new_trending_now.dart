import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_song.dart';

class NewTrendingNow {
  final List<NewSong> songs;
  final List<NewAlbum> albums;

  NewTrendingNow({required this.songs, required this.albums});

  factory NewTrendingNow.fromList({required List<NewAlbum> albums, required List<NewSong> songs}) {
    return NewTrendingNow(
      albums: albums,
      songs: songs
    );
  }

  factory NewTrendingNow.empty() {
    return NewTrendingNow(songs: [], albums: []);
  }
}
