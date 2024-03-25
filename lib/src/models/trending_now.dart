import 'package:sonicity/src/models/models.dart';

class TrendingNow {
  final List<Song> songs;
  final List<Album> albums;

  TrendingNow({required this.songs, required this.albums});

  factory TrendingNow.fromList({required List<Album> albums, required List<Song> songs}) {
    return TrendingNow(
      albums: albums,
      songs: songs
    );
  }

  factory TrendingNow.empty() {
    return TrendingNow(songs: [], albums: []);
  }

  void clear() {
    songs.clear();
    albums.clear();
  }
}
