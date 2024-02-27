import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/search_all.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/song_details_api.dart';

class SearchAllApi {
  static Future<Map<String, dynamic>> _searchAll(String text) async {
    text = text.replaceAll(" ", "+");
    final uri = Uri.parse('https://saavn.dev/search/all?query=$text');

    final response = await http.get(uri);
    final jsonMap = jsonDecode(response.body);
    final data = jsonMap["data"];
    return data;
  }

  static Future<SearchAll> searchAll(String text) async {
    final data = await _searchAll(text);
    TopQuery topQuery = await _getTopQuery(data["topQuery"]["results"]);
    List<Song> songs = await _getSongsList(data["songs"]["results"]);
    List<Album> albums = await _getAlbumsList(data["albums"]["results"]);
    List<Artist> artists = await _getArtistsList(data["artists"]["results"]);
    List<Playlist> playlists = await _getPlaylistsList(data["playlists"]["results"]);
    return SearchAll.fromLists(topQuery: topQuery, songs: songs, albums: albums, artists: artists, playlists: playlists);
  }

  static Future<TopQuery> _getTopQuery(List<dynamic> topQuery) async {
    List<Song> songs = [];
    List<Artist> artists = [];
    List<Album> albums = [];
    List<Playlist> playlists = [];
    for(var result in topQuery) {
      String id = result['id'];
      String type = result['type'];
      if(type == 'song') {
        Song song = await SongDetailsApi.get(id);
        songs.add(song);
      } else if(type == 'artist') {
        Artist artist = Artist.image(result);
        artists.add(artist);
      } else if(type == 'album') {
        Album album = Album.image(result);
        albums.add(album);
      } else if(type == 'playlist') {
        Playlist playlist = Playlist.image(result);
        playlists.add(playlist);
      }
    }
    return TopQuery.fromJson(songs: songs, albums: albums, artists: artists, playlists: playlists);
  }
  
  static Future<List<Song>> _getSongsList(List<dynamic> songList) async {
    List<Song> songs = [];
    for(var result in songList) {
      Song song = await SongDetailsApi.forPlay(result['id']);
      songs.add(song);
    }
    return songs;
  }

  static Future<List<Album>> _getAlbumsList(List<dynamic> albumList) async {
    List<Album> albums = [];
    for(var result in albumList) {
      Album album = Album.language(result);
      albums.add(album);
    }
    return albums;
  }

  static Future<List<Artist>> _getArtistsList(List<dynamic> artistList) async {
    List<Artist> artists = [];
    for(var result in artistList) {
      Artist artist = Artist.description(result);
      artists.add(artist);
    }
    return artists;
  }

  static Future<List<Playlist>> _getPlaylistsList(List<dynamic> playlistList) async {
    List<Playlist> playlists = [];
    for(var result in playlistList) {
      Playlist playlist = Playlist.language(result);
      playlists.add(playlist);
    }
    return playlists;
  }
}