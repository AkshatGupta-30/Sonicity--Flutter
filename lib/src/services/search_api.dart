import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/models/top_query.dart';
import 'package:sonicity/src/services/album_details_api.dart';
import 'package:sonicity/src/services/artist_details_api.dart';
import 'package:sonicity/src/services/playlist_details_api.dart';
import 'package:sonicity/src/services/song_details_api.dart';

class SearchViewApi {
  static Future<Map<String, dynamic>> _searchAll(String text) async {
    text = text.replaceAll(" ", "+");
    final uri = Uri.parse('https://saavn.dev/search/all?query=$text');

    final body = await _fetchData(uri);
    final jsonMap = jsonDecode(body);
    final data = jsonMap["data"];
    return data;
  }

  static Future<String> _fetchData(Uri uri) async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response);
    }
  }

  static Future<TopQuery> searchTopQuery(String text) async {
    final data = await _searchAll(text);
    TopQuery topQuery = await _getTopQuery(data["topQuery"]["results"]);
    return topQuery;
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
        Song song = await SongDetailsApi.short(id);
        songs.add(song);
      } else if(type == 'artist') {
        Artist artist = await ArtistDetailsApi.short(id);
        artists.add(artist);
      } else if(type == 'album') {
        Album album = await AlbumDetailsApi.short(id);
        albums.add(album);
      } else if(type == 'playlist') {
        Playlist playlist = await PlaylistDetailsApi.short(id);
        playlists.add(playlist);
      }
    }
    return TopQuery.fromJson(songs: songs, albums: albums, artists: artists, playlists: playlists);
  }
}