import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';
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

  Future _onCreate(Database db, int version) async {
    await db.execute( // * Tremdong Songs
      '''
        CREATE TABLE $dbHomeTbTrendingSongs (
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
        CREATE TABLE $dbHomeTbTrendingAlbums (
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
        CREATE TABLE $dbHomeTbTopCharts (
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
        CREATE TABLE $dbHomeTbTopAlbums (
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
        CREATE TABLE $dbHomeTbHotPlaylists (
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
    for (var song in trendNow.songs) (await db.insert(dbHomeTbTrendingSongs, song.toDb()));
    for (var album in trendNow.albums) (await db.insert(dbHomeTbTrendingAlbums, album.toDb()));
    for (var playlist in tpChart.playlists) {
      Map<String,dynamic> playlistDb = {
        "playlist_id" : playlist.id,
        "name" : playlist.name,
        "language" : playlist.language,
        "img_low" : playlist.image.lowQuality,
        "img_med" : playlist.image.medQuality,
        "img_high" : playlist.image.highQuality,
      };
      await db.insert(dbHomeTbTopCharts, playlistDb);
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
      await db.insert(dbHomeTbTopAlbums, albumDb);
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
      await db.insert(dbHomeTbHotPlaylists, playlistDb);
    }
  }

  Future<(TrendingNow, TopCharts, TopAlbums, HotPlaylists)> get all async {
    Database db = await _instance.database;
    List<Song> trendSongs = [];
    List<Album> trendAlbums = [];
    List<Playlist> tpChart = [];
    List<Album> tpAlbum = [];
    List<Playlist> htPlaylist = [];

    List<Map<String,dynamic>> trendSongsResult = await db.query(dbHomeTbTrendingSongs);
    for (var map in trendSongsResult) trendSongs.add(Song.fromDb(map));

    List<Map<String,dynamic>> trendAlbumsResult = await db.query(dbHomeTbTrendingAlbums);
    for (var map in trendAlbumsResult) trendAlbums.add(Album.fromDb(map));

    List<Map<String,dynamic>> topChartsResult = await db.query(dbHomeTbTopCharts);
    for (var map in topChartsResult) tpChart.add(Playlist.fromDb(map));

    List<Map<String,dynamic>> topAlbumsResult = await db.query(dbHomeTbTopAlbums);
    for (var map in topAlbumsResult) tpAlbum.add(Album.fromDb(map));

    List<Map<String,dynamic>> hotPlaylistsResult = await db.query(dbHomeTbHotPlaylists);
    for (var map in hotPlaylistsResult) htPlaylist.add(Playlist.fromDb(map));

    return (
      TrendingNow.fromList(albums: trendAlbums, songs: trendSongs),
      TopCharts.fromList(jsonList: tpChart),
      TopAlbums.fromJson(jsonList: tpAlbum),
      HotPlaylists.fromJson(jsonList: htPlaylist)
    );
  }

  Future<TrendingNow> get trending async {
    Database db = await _instance.database;
    List<Song> trendSongs = [];
    List<Album> trendAlbums = [];

    List<Map<String,dynamic>> trendSongsResult = await db.query(dbHomeTbTrendingSongs);
    for (var map in trendSongsResult) trendSongs.add(Song.fromDb(map));

    List<Map<String,dynamic>> trendAlbumsResult = await db.query(dbHomeTbTrendingAlbums);
    for (var map in trendAlbumsResult) trendAlbums.add(Album.fromDb(map));

    return TrendingNow.fromList(albums: trendAlbums, songs: trendSongs);
  }

  Future<TopCharts> get topCharts async {
    Database db = await _instance.database;
    List<Playlist> tpChart = [];

    List<Map<String,dynamic>> topChartsResult = await db.query(dbHomeTbTopCharts);
    for (var map in topChartsResult) tpChart.add(Playlist.fromDb(map));
    return TopCharts.fromList(jsonList: tpChart);
  }

  Future<TopAlbums> get topAlbums async {
    Database db = await _instance.database;
    List<Album> tpAlbum = [];

    List<Map<String,dynamic>> topAlbumsResult = await db.query(dbHomeTbTopAlbums);
    for (var map in topAlbumsResult) tpAlbum.add(Album.fromDb(map));
    return TopAlbums.fromJson(jsonList: tpAlbum);
  }

  Future<HotPlaylists> get hotPlaylist async {
    Database db = await _instance.database;
    List<Playlist> htPlaylist = [];

    List<Map<String,dynamic>> hotPlaylistsResult = await db.query(dbHomeTbHotPlaylists);
    for (var map in hotPlaylistsResult) htPlaylist.add(Playlist.fromDb(map));
    return HotPlaylists.fromJson(jsonList: htPlaylist);
  }

  Future<bool> isFilled() async {
    Database db = await _instance.database;
    final trS = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbHomeTbTrendingSongs'));
    final trA = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbHomeTbTrendingAlbums'))!;
    final tC = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbHomeTbTopCharts'))!;
    final tA = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbHomeTbTopAlbums'))!;
    final hP = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbHomeTbHotPlaylists'))!;
    return (trS!=0 || trA!=0 || tC!=0 || tA!=0 || hP!=0);
  }

  void clearAll() async {
    Database db = await _instance.database;
    List<String> tables = [dbHomeTbTrendingSongs, dbHomeTbTrendingAlbums, dbHomeTbTopCharts, dbHomeTbTopAlbums, dbHomeTbHotPlaylists];
    for (String table in tables) {
      await db.delete(table);
    }
  }

  void dispose() async {
    final db = await _instance.database;
    db.close();
  }
}
