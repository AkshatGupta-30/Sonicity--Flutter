import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/hot_playlists.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/src/models/top_charts.dart';
import 'package:sonicity/src/models/trending_now.dart';
import 'package:sqflite/sqflite.dart';

class HomeDatabase {
  HomeDatabase._();
  static final HomeDatabase _instance = HomeDatabase._();
  factory HomeDatabase() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const _databaseName = "home_data.db";
  static const _databaseVersion = 1;
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}$_databaseName";
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static const tbTrendingSongs = 'trending_songs';
  static const tbTrendingAlbums = 'trending_albums';
  static const tbTopCharts = 'top_charts';
  static const tbTopAlbums = 'top_albums';
  static const tbHotPlaylists = 'hot_playlist';

  static const colId = 'id';
  static const colSongId = 'song_id';
  static const colAlbumId = 'album_id';
  static const colArtistId = 'artist_id';
  static const colPlaylistId = 'playlist_id';
  static const colName = 'name';
  static const colAlbumName = 'album_name';
  static const colArtistIds = 'artist_ids';
  static const colArtistNames = 'artist_names';
  static const colHasLyrics = 'hasLyrics';
  static const colYear = 'year';
  static const colReleaseDate = 'releaseDate';
  static const colDuration = 'duration';
  static const colLanguage = 'language';
  static const colSongCount = 'songCount';
  static const colDominantType = 'dominantType';
  static const colImgLow = 'img_low';
  static const colImgMed = 'img_med';
  static const colImgHigh = 'img_high';
  static const colDownload12kbps = 'download_12kbps';
  static const colDownload48kbps = 'download_48kbps';
  static const colDownload96kbps = 'download_96kbps';
  static const colDownload160kbps = 'download_160kbps';
  static const colDownload320kbps = 'download_320kbps';
  Future _onCreate(Database db, int version) async {
    await db.execute( // * Tremdong Songs
      '''
        CREATE TABLE $tbTrendingSongs (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colSongId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colAlbumId TEXT,
          $colAlbumName TEXT,
          $colArtistIds TEXT,
          $colArtistNames TEXT,
          $colHasLyrics INTEGER,
          $colYear TEXT,
          $colReleaseDate TEXT,
          $colDuration TEXT,
          $colLanguage TEXT,
          $colImgLow TEXT,
          $colImgMed TEXT,
          $colImgHigh TEXT,
          $colDownload12kbps TEXT,
          $colDownload48kbps TEXT,
          $colDownload96kbps TEXT,
          $colDownload160kbps TEXT,
          $colDownload320kbps TEXT
        )
      '''
    );
    await db.execute(// * Trending Albums
      '''
        CREATE TABLE $tbTrendingAlbums (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colAlbumId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colSongCount TEXT,
          $colImgLow TEXT,
          $colImgMed TEXT,
          $colImgHigh TEXT
        )
      '''
    );
    await db.execute(// * Top Charts
      '''
        CREATE TABLE $tbTopCharts (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colPlaylistId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colLanguage TEXT,
          $colImgLow TEXT,
          $colImgMed TEXT,
          $colImgHigh TEXT
        )
      '''
    );
    await db.execute(// * TopAlbums
      '''
        CREATE TABLE $tbTopAlbums (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colAlbumId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colLanguage TEXT,
          $colImgLow TEXT,
          $colImgMed TEXT,
          $colImgHigh TEXT
        )
      '''
    );
    await db.execute(// * Hot Playlists
      '''
        CREATE TABLE $tbHotPlaylists (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colPlaylistId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colSongCount TEXT,
          $colImgLow TEXT,
          $colImgMed TEXT,
          $colImgHigh TEXT
        )
      '''
    );
  }

  Future<void> insertData({
    required TrendingNow trendNow,
    required TopCharts  tpChart,
    required TopAlbums tpAlbum,
    required HotPlaylists htPlaylist,
  }) async {
    Database db = await _instance.database;
    for (var song in trendNow.songs) (await db.insert(tbTrendingSongs, song.toDb()));
    for (var album in trendNow.albums) (await db.insert(tbTrendingAlbums, album.toDb()));
    for (var playlist in tpChart.playlists) {
      Map<String,dynamic> playlistDb = {
        "playlist_id" : playlist.id,
        "name" : playlist.name,
        "language" : playlist.language,
        "img_low" : playlist.image.lowQuality,
        "img_med" : playlist.image.medQuality,
        "img_high" : playlist.image.highQuality,
      };
      await db.insert(tbTopCharts, playlistDb);
    }
    for (var album in tpAlbum.albums) {
      Map<String,dynamic> albumDb = {
        "album_id" : album.id,
        "name" : album.name,
        "language" : album.language,
        "img_low" : album.image!.lowQuality,
        "img_med" : album.image!.medQuality,
        "img_high" : album.image!.highQuality,
      };
      await db.insert(tbTopAlbums, albumDb);
    }
    for (var playlist in htPlaylist.playlists) {
      Map<String,dynamic> playlistDb = {
        "playlist_id" : playlist.id,
        "name" : playlist.name,
        "songCount" : playlist.songCount,
        "img_low" : playlist.image.lowQuality,
        "img_med" : playlist.image.medQuality,
        "img_high" : playlist.image.highQuality,
      };
      await db.insert(tbHotPlaylists, playlistDb);
    }
  }

  Future<(TrendingNow, TopCharts, TopAlbums, HotPlaylists)> get all async {
    Database db = await _instance.database;
    List<Song> trendSongs = [];
    List<Album> trendAlbums = [];
    List<Playlist> tpChart = [];
    List<Album> tpAlbum = [];
    List<Playlist> htPlaylist = [];

    List<Map<String,dynamic>> trendSongsResult = await db.query(tbTrendingSongs);
    for (var map in trendSongsResult) trendSongs.add(Song.fromDb(map));

    List<Map<String,dynamic>> trendAlbumsResult = await db.query(tbTrendingAlbums);
    for (var map in trendAlbumsResult) trendAlbums.add(Album.fromDb(map));

    List<Map<String,dynamic>> topChartsResult = await db.query(tbTopCharts);
    for (var map in topChartsResult) tpChart.add(Playlist.fromDb(map));

    List<Map<String,dynamic>> topAlbumsResult = await db.query(tbTopAlbums);
    for (var map in topAlbumsResult) tpAlbum.add(Album.fromDb(map));

    List<Map<String,dynamic>> hotPlaylistsResult = await db.query(tbHotPlaylists);
    for (var map in hotPlaylistsResult) htPlaylist.add(Playlist.fromDb(map));

    return (
      TrendingNow.fromList(albums: trendAlbums, songs: trendSongs),
      TopCharts.fromList(jsonList: tpChart),
      TopAlbums.fromJson(jsonList: tpAlbum),
      HotPlaylists.fromJson(jsonList: htPlaylist)
    );
  }

  void clearAll() async {
    Database db = await _instance.database;
    List<String> tables = [tbTrendingSongs, tbTrendingAlbums, tbTopCharts, tbTopAlbums, tbHotPlaylists];
    for (String table in tables) {
      await db.delete(table);
    }
  }
}
