import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/models/new_song.dart';

enum Category{alphabetical, latest}
enum Sort{asc, desc}

class NewArtistSongAlbum {
  final NewArtist artist;
  final List<NewAlbum> albums;
  final List<NewSong> songs;

  NewArtistSongAlbum({required this.artist, required this.albums, required this.songs});

  factory NewArtistSongAlbum.fill({required NewArtist artist, required List<NewAlbum> albums, required List<NewSong> songs}) {
    return NewArtistSongAlbum(artist: artist, albums: albums, songs: songs);
  }

  factory NewArtistSongAlbum.empty() {
    return NewArtistSongAlbum(artist: NewArtist.empty(), albums: [], songs: []);
  }
}