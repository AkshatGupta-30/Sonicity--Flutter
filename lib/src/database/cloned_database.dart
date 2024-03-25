import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sqflite/sqflite.dart';

class ClonedDatabase {
  ClonedDatabase._();
  static final ClonedDatabase _instance = ClonedDatabase._();
  factory ClonedDatabase() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const _databaseName = "cloned.db";
  static const _databaseVersion = 1;
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}$_databaseName";
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate,);
  }

  // TODO : separate class for this
  static const tbSongDetail = 'cloned_song';
  static const tbAlbumDetail = 'cloned_album';
  static const tbArtistDetail = 'cloned_artist';
  static const tbPlaylistDetail = 'cloned_playlist';

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
    await db.execute( // * Song Details
      '''
        CREATE TABLE $tbSongDetail (
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
        CREATE TABLE $tbAlbumDetail (
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
        CREATE TABLE $tbArtistDetail (
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
        CREATE TABLE $tbPlaylistDetail (
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

  Future<void> clone(dynamic model) async {
    Database db = await _instance.database;
    if(await isPresent(model)) return;
    Map<Type, String> tableNames = {
      Song: tbSongDetail,
      Album: tbAlbumDetail,
      Artist: tbArtistDetail,
      Playlist: tbPlaylistDetail,
    };
    if (tableNames.containsKey(model.runtimeType)) {
      await db.insert(tableNames[model.runtimeType]!, model.toDb());
    }
  }

  Future<void> deleteClone(dynamic model) async {
    getIt<StarredDatabase>().deleteStarred(model);
    Database db = await _instance.database;
    Map<Type, Map<String, dynamic>> modelsMap = {
      Song: {tbSongDetail: colSongId},
      Album: {tbAlbumDetail: colAlbumId},
      Artist: {tbArtistDetail: colArtistId},
      Playlist: {tbPlaylistDetail: colPlaylistId}
    };

    final tableColumn = modelsMap[model.runtimeType];
    await db.delete(tableColumn!.keys.first, where: '${tableColumn.values.first} = ?', whereArgs: [model.id]);
  }

  Future<bool> isPresent(dynamic model) async {
    Database db = await _instance.database;
    Map<Type, Map<String, dynamic>> modelsMap = {
      Song: {tbSongDetail: colSongId},
      Album: {tbAlbumDetail: colAlbumId},
      Artist: {tbArtistDetail: colArtistId},
      Playlist: {tbPlaylistDetail: colPlaylistId}
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
    
    List<Map<String,dynamic>> songResult = await db.query(tbSongDetail);
    for (var map in songResult)  songs.add(Song.fromDb(map));

    List<Map<String,dynamic>> albumResult = await db.query(tbAlbumDetail);
    for (var map in albumResult) albums.add(Album.fromDb(map));

    List<Map<String,dynamic>> artistResult = await db.query(tbArtistDetail);
    for (var map in artistResult) artists.add(Artist.fromDb(map));

    List<Map<String,dynamic>> playlistResult = await db.query(tbPlaylistDetail);
    for (var map in playlistResult) playlists.add(Playlist.fromDb(map));

    return (songs, albums, artists, playlists);
  }

  Future<List<Song>> get songs async {
    Database db = await _instance.database;
    List<Song> songs = [];
    List<Map<String,dynamic>> songResult = await db.query(tbSongDetail);
    for (var map in songResult)  songs.add(Song.fromDb(map));
    return songs;
  }

  Future<List<Album>> get albums async {
    Database db = await _instance.database;
    List<Album> albums = [];
    List<Map<String,dynamic>> albumResult = await db.query(tbAlbumDetail);
    for (var map in albumResult) albums.add(Album.fromDb(map));
    return albums;
  }

  Future<List<Artist>> get artists async {
    Database db = await _instance.database;
    List<Artist> artists = [];
    List<Map<String,dynamic>> artistResult = await db.query(tbArtistDetail);
    for (var map in artistResult) artists.add(Artist.fromDb(map));
    return artists;
  }

  Future<List<Playlist>> get playlists async {
    Database db = await _instance.database;
    List<Playlist> playlists = [];
    List<Map<String,dynamic>> playlistResult = await db.query(tbPlaylistDetail);
    for (var map in playlistResult) playlists.add(Playlist.fromDb(map));
    return playlists;
  }

  Future<int> get count async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tbSongDetail'));
    if(count == null) return 0;
    return count;
  }
}
