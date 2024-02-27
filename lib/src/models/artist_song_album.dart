import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';

enum Category{alphabetical, latest}
enum Sort{asc, desc}

class ArtistSongAlbum {
  final Artist artist;
  final List<Album> albums;
  final List<Song> songs;

  ArtistSongAlbum({required this.artist, required this.albums, required this.songs});

  factory ArtistSongAlbum.fill({required Artist artist, required List<Album> albums, required List<Song> songs}) {
    return ArtistSongAlbum(artist: artist, albums: albums, songs: songs);
  }

  factory ArtistSongAlbum.empty() {
    return ArtistSongAlbum(artist: Artist.empty(), albums: [], songs: []);
  }
}