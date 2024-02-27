import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/models/new_playlist.dart';
import 'package:sonicity/src/models/new_song.dart';

class NewTopQuery{
  final List<NewSong> songs;
  final List<NewAlbum> albums;
  final List<NewArtist> artists;
  final List<NewPlaylist> playlists;

  NewTopQuery({required this.songs, required this.albums, required this.artists, required this.playlists});

  factory NewTopQuery.fromJson({
    required List<NewSong> songs,
    required List<NewAlbum> albums,
    required List<NewArtist> artists,
    required List<NewPlaylist> playlists
  }) {
    return NewTopQuery(songs: songs, albums: albums, artists: artists, playlists: playlists);
  }

  bool isEmpty() {
    if(songs.isEmpty && albums.isEmpty && artists.isEmpty && playlists.isEmpty) {
      return true;
    }
    return false;
  }

  bool isNotEmpty() {
    if(songs.isEmpty && albums.isEmpty && artists.isEmpty && playlists.isEmpty) {
      return false;
    }
    return true;
  }

  void clear() {
    songs.clear();
    albums.clear();
    artists.clear();
    playlists.clear();
  }
}

class NewSearchAll {
  final NewTopQuery topQuery;
  final List<NewSong> songs;
  final List<NewAlbum> albums;
  final List<NewArtist> artists;
  final List<NewPlaylist> playlists;

  NewSearchAll({required this.topQuery, required this.songs, required this.albums, required this.artists, required this.playlists});

  factory NewSearchAll.fromLists({
    required NewTopQuery topQuery,
    required List<NewSong> songs,
    required List<NewAlbum> albums,
    required List<NewArtist> artists,
    required List<NewPlaylist> playlists
  }) {
    return NewSearchAll(topQuery: topQuery, songs: songs, albums: albums, artists: artists, playlists: playlists);
  }

  void clear() {
    topQuery.clear();
    songs.clear();
    albums.clear();
    artists.clear();
    playlists.clear();
  }
}