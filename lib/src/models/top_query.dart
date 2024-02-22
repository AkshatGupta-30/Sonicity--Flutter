import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';

class TopQuery{
  final List<Song> songs;
  final List<Album> albums;
  final List<Artist> artists;
  final List<Playlist> playlists;

  TopQuery({required this.songs, required this.albums, required this.artists, required this.playlists});

  factory TopQuery.fromJson({
    required List<Song> songs,
    required List<Album> albums,
    required List<Artist> artists,
    required List<Playlist> playlists
  }) {
    return TopQuery(songs: songs, albums: albums, artists: artists, playlists: playlists);
  }
}