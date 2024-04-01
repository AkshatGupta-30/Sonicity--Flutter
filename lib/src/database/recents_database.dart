import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sqflite/sqflite.dart';

class RecentsDatabase {
  RecentsDatabase._();
  static final RecentsDatabase _instance = RecentsDatabase._();
  factory RecentsDatabase() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const _databaseName = "recents_songs.db";
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
    await db.execute( // * Song Details
      '''
        CREATE TABLE $dbRecentsTbSongDetail (
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
    await db.execute(// * Album Details
      '''
        CREATE TABLE $dbRecentsTbAlbumDetail (
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
    await db.execute(// * Artist Details
      '''
        CREATE TABLE $dbRecentsTbArtistDetail (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colArtistId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colDominantType TEXT,
          $colImgLow TEXT,
          $colImgMed TEXT,
          $colImgHigh TEXT
        )
      '''
    );
    await db.execute(// * Playlist Details
      '''
        CREATE TABLE $dbRecentsTbPlaylistDetail (
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

  Future<void> insertSong(Song song) async {
    Database db = await _instance.database;
    await db.delete(dbRecentsTbSongDetail, where: '$colSongId = ?', whereArgs: [song.id]);
    int maxCount = Get.find<SettingsController>().getRecentsMaxLength;
    if(await count == maxCount) _deleteFirstRow(dbRecentsTbSongDetail);
    await db.insert(dbRecentsTbSongDetail, song.toDb());
  }

  Future<void> insertAlbum(Album album) async {
    Database db = await _instance.database;
    await db.delete(dbRecentsTbAlbumDetail, where: '$colAlbumId = ?', whereArgs: [album.id]);
    int maxCount = Get.find<SettingsController>().getRecentsMaxLength;
    if(await count == maxCount) _deleteFirstRow(dbRecentsTbAlbumDetail);
    await db.insert(dbRecentsTbAlbumDetail, album.toDb());
  }

  Future<void> insertArtist(Artist artist) async {
    Database db = await _instance.database;
    await db.delete(dbRecentsTbArtistDetail, where: '$colArtistId = ?', whereArgs: [artist.id]);
    int maxCount = Get.find<SettingsController>().getRecentsMaxLength;
    if(await count == maxCount) _deleteFirstRow(dbRecentsTbArtistDetail);
    await db.insert(dbRecentsTbArtistDetail, artist.toDb());
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    Database db = await _instance.database;
    await db.delete(dbRecentsTbPlaylistDetail, where: '$colPlaylistId = ?', whereArgs: [playlist.id]);
    int maxCount = Get.find<SettingsController>().getRecentsMaxLength;
    if(await count == maxCount) _deleteFirstRow(dbRecentsTbPlaylistDetail);
    await db.insert(dbRecentsTbPlaylistDetail, playlist.toDb());
  }

  Future<(List<Song>, List<Album>, List<Artist>, List<Playlist>)> get all async {
    Database db = await _instance.database;
    List<Song> songs = [];
    List<Album> albums = [];
    List<Artist> artists = [];
    List<Playlist> playlists = [];
    
    List<Map<String,dynamic>> songResult = await db.query(dbRecentsTbSongDetail);
    for (var map in songResult)  songs.add(Song.fromDb(map));

    List<Map<String,dynamic>> albumResult = await db.query(dbRecentsTbAlbumDetail);
    for (var map in albumResult) albums.add(Album.fromDb(map));

    List<Map<String,dynamic>> artistResult = await db.query(dbRecentsTbArtistDetail);
    for (var map in artistResult) artists.add(Artist.fromDb(map));

    List<Map<String,dynamic>> playlistResult = await db.query(dbRecentsTbPlaylistDetail);
    for (var map in playlistResult) playlists.add(Playlist.fromDb(map));

    return (songs, albums, artists, playlists);
  }

  Future<List<Album>> getAlbums() async {
    Database db = await _instance.database;
    List<Album> albums = [];
    List<Map<String,dynamic>> result = await db.query(dbRecentsTbAlbumDetail);
    for (var map in result) {
      albums.add(Album.fromDb(map));
    }
    return albums;
  }

  Future<List<Artist>> getArtists() async {
    Database db = await _instance.database;
    List<Artist> artists = [];
    List<Map<String,dynamic>> result = await db.query(dbRecentsTbArtistDetail);
    for (var map in result) {
      artists.add(Artist.fromDb(map));
    }
    return artists;
  }

  Future<List<Playlist>> getPlaylists() async {
    Database db = await _instance.database;
    List<Playlist> playlists = [];
    List<Map<String,dynamic>> result = await db.query(dbRecentsTbPlaylistDetail);
    for (var map in result) {
      playlists.add(Playlist.fromDb(map));
    }
    return playlists;
  }

  Future<int> get count async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbRecentsTbSongDetail'));
    if(count == null) return 0;
    return count;
  }

  void _deleteFirstRow(String tableName) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> rows = await db.query(tableName, limit: 1);
    int? firstRowId = rows.isNotEmpty ? rows.first['id'] : null;
    if (firstRowId != null) {
      await db.delete(tableName, where: 'id = ?', whereArgs: [firstRowId]);
    }
  }

  void dispose() async {
    final db = await _instance.database;
    db.close();
  }
}
