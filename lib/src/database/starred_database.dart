import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sqflite/sqflite.dart';

class StarredDatabase {
  StarredDatabase._();
  static final StarredDatabase _instance = StarredDatabase._();
  factory StarredDatabase() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const _databaseName = "starred.db";
  static const _databaseVersion = 1;
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}$_databaseName";
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate,);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute( // * Song Details
      '''
        CREATE TABLE $dbStarredTbSongDetail (
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
        CREATE TABLE $dbStarredTbAlbumDetail (
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
        CREATE TABLE $dbStarredTbArtistDetail (
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
        CREATE TABLE $dbStarredTbPlaylistDetail (
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

  Future<void> starred(dynamic model) async {
    Database db = await _instance.database;
    Map<Type, String> tableNames = {
      Song: dbStarredTbSongDetail,
      Album: dbStarredTbAlbumDetail,
      Artist: dbStarredTbArtistDetail,
      Playlist: dbStarredTbPlaylistDetail,
    };
    if (tableNames.containsKey(model.runtimeType)) {
      getIt<ClonedDatabase>().clone(model);
      await db.insert(tableNames[model.runtimeType]!, model.toDb());
    }
  }

  Future<void> deleteStarred(dynamic model) async {
    Database db = await _instance.database;
    Map<Type, Map<String, dynamic>> modelsMap = {
      Song: {dbStarredTbSongDetail: colSongId},
      Album: {dbStarredTbAlbumDetail: colAlbumId},
      Artist: {dbStarredTbArtistDetail: colArtistId},
      Playlist: {dbStarredTbPlaylistDetail: colPlaylistId}
    };

    final tableColumn = modelsMap[model.runtimeType];
    await db.delete(tableColumn!.keys.first, where: '${tableColumn.values.first} = ?', whereArgs: [model.id]);
  }

  Future<bool> isPresent(dynamic model) async {
    Database db = await _instance.database;
    Map<Type, Map<String, dynamic>> modelsMap = {
      Song: {dbStarredTbSongDetail: colSongId},
      Album: {dbStarredTbAlbumDetail: colAlbumId},
      Artist: {dbStarredTbArtistDetail: colArtistId},
      Playlist: {dbStarredTbPlaylistDetail: colPlaylistId}
    };

    final tableColumn = modelsMap[model.runtimeType];
    final result = await db.query(tableColumn!.keys.first, where: '${tableColumn.values.first} = ?', whereArgs: [model.id]);
    return result.isNotEmpty;
  }

  Future<(List<Song>, List<Album>, List<Artist>, List<Playlist>)> get all async {
    Database db = await _instance.database;
    List<Song> songs = [];
    List<Album> albums = [];
    List<Artist> artists = [];
    List<Playlist> playlists = [];
    
    List<Map<String,dynamic>> songResult = await db.query(dbStarredTbSongDetail);
    for (var map in songResult)  songs.add(Song.fromDb(map));

    List<Map<String,dynamic>> albumResult = await db.query(dbStarredTbAlbumDetail);
    for (var map in albumResult) albums.add(Album.fromDb(map));

    List<Map<String,dynamic>> artistResult = await db.query(dbStarredTbArtistDetail);
    for (var map in artistResult) artists.add(Artist.fromDb(map));

    List<Map<String,dynamic>> playlistResult = await db.query(dbStarredTbPlaylistDetail);
    for (var map in playlistResult) playlists.add(Playlist.fromDb(map));

    return (songs, albums, artists, playlists);
  }

  Future<List<Song>> get songs async {
    Database db = await _instance.database;
    List<Song> songs = [];
    List<Map<String,dynamic>> songResult = await db.query(dbStarredTbSongDetail);
    for (var map in songResult)  songs.add(Song.fromDb(map));
    return songs;
  }

  Future<List<Album>> get albums async {
    Database db = await _instance.database;
    List<Album> albums = [];
    List<Map<String,dynamic>> albumResult = await db.query(dbStarredTbAlbumDetail);
    for (var map in albumResult) albums.add(Album.fromDb(map));
    return albums;
  }

  Future<List<Artist>> get artists async {
    Database db = await _instance.database;
    List<Artist> artists = [];
    List<Map<String,dynamic>> artistResult = await db.query(dbStarredTbArtistDetail);
    for (var map in artistResult) artists.add(Artist.fromDb(map));
    return artists;
  }

  Future<List<Playlist>> get playlists async {
    Database db = await _instance.database;
    List<Playlist> playlists = [];
    List<Map<String,dynamic>> playlistResult = await db.query(dbStarredTbPlaylistDetail);
    for (var map in playlistResult) playlists.add(Playlist.fromDb(map));
    return playlists;
  }

  Future<int> get count async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbStarredTbSongDetail'));
    if(count == null) return 0;
    return count;
  }

  void dispose() async {
    final db = await _instance.database;
    db.close();
  }
}
