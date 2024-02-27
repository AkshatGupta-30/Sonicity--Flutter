import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/models/new_playlist.dart';
import 'package:sonicity/src/models/new_search_all.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:sonicity/src/services/new_song_details_api.dart';

class NewSearchAllApi {
  static Future<Map<String, dynamic>> _searchAll(String text) async {
    text = text.replaceAll(" ", "+");
    final uri = Uri.parse('https://saavn.dev/search/all?query=$text');

    final response = await http.get(uri);
    final jsonMap = jsonDecode(response.body);
    final data = jsonMap["data"];
    return data;
  }

  static Future<NewSearchAll> searchAll(String text) async {
    final data = await _searchAll(text);
    NewTopQuery topQuery = await _getTopQuery(data["topQuery"]["results"]);
    List<NewSong> songs = await _getSongsList(data["songs"]["results"]);
    List<NewAlbum> albums = await _getAlbumsList(data["albums"]["results"]);
    List<NewArtist> artists = await _getArtistsList(data["artists"]["results"]);
    List<NewPlaylist> playlists = await _getPlaylistsList(data["playlists"]["results"]);
    return NewSearchAll.fromLists(topQuery: topQuery, songs: songs, albums: albums, artists: artists, playlists: playlists);
  }

  static Future<NewTopQuery> _getTopQuery(List<dynamic> topQuery) async {
    List<NewSong> songs = [];
    List<NewArtist> artists = [];
    List<NewAlbum> albums = [];
    List<NewPlaylist> playlists = [];
    for(var result in topQuery) {
      String id = result['id'];
      String type = result['type'];
      if(type == 'song') {
        NewSong song = await NewSongDetailsApi.get(id);
        songs.add(song);
      } else if(type == 'artist') {
        NewArtist artist = NewArtist.image(result);
        artists.add(artist);
      } else if(type == 'album') {
        NewAlbum album = NewAlbum.image(result);
        albums.add(album);
      } else if(type == 'playlist') {
        NewPlaylist playlist = NewPlaylist.image(result);
        playlists.add(playlist);
      }
    }
    return NewTopQuery.fromJson(songs: songs, albums: albums, artists: artists, playlists: playlists);
  }
  
  static Future<List<NewSong>> _getSongsList(List<dynamic> songList) async {
    List<NewSong> songs = [];
    for(var result in songList) {
      NewSong song = await NewSongDetailsApi.get(result['id']);
      songs.add(song);
    }
    return songs;
  }

  static Future<List<NewAlbum>> _getAlbumsList(List<dynamic> albumList) async {
    List<NewAlbum> albums = [];
    for(var result in albumList) {
      NewAlbum album = NewAlbum.language(result);
      albums.add(album);
    }
    return albums;
  }

  static Future<List<NewArtist>> _getArtistsList(List<dynamic> artistList) async {
    List<NewArtist> artists = [];
    for(var result in artistList) {
      NewArtist artist = NewArtist.description(result);
      artists.add(artist);
    }
    return artists;
  }

  static Future<List<NewPlaylist>> _getPlaylistsList(List<dynamic> playlistList) async {
    List<NewPlaylist> playlists = [];
    for(var result in playlistList) {
      NewPlaylist playlist = NewPlaylist.language(result);
      playlists.add(playlist);
    }
    return playlists;
  }
}