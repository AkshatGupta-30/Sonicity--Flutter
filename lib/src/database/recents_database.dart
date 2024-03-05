import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/models/song.dart';
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

  static const tbSongDetail = 'song_details';

  static const colId = 'id';
  static const colSongId = 'song_id';
  static const colName = 'name';
  static const colAlbumId = 'album_id';
  static const colAlbumName = 'album_name';
  static const colArtistIds = 'artist_ids';
  static const colArtistNames = 'artist_names';
  static const colHasLyrics = 'hasLyrics';
  static const colYear = 'year';
  static const colReleaseDate = 'releaseDate';
  static const colDuration = 'duration';
  static const colLanguage = 'language';
  static const colImgLow = 'img_low';
  static const colImgMed = 'img_med';
  static const colImgHigh = 'img_high';
  static const colDownload12kbps = 'download_12kbps';
  static const colDownload48kbps = 'download_48kbps';
  static const colDownload96kbps = 'download_96kbps';
  static const colDownload160kbps = 'download_160kbps';
  static const colDownload320kbps = 'download_320kbps';
  Future _onCreate(Database db, int version) async {
    await db.execute(
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
  }

  Future<int> insert(Song song) async {
    Database db = await _instance.database;
    _insertCheck(song.id);
    (await count()).printInfo();
    return await db.insert(tbSongDetail, song.toDbDetailsMap());
  }

  Future<List<Song>> getAll() async {
    Database db = await _instance.database;
    List<Song> songs = [];
    List<Map<String,dynamic>> result = await db.query(tbSongDetail);
    for (var map in result) {
      songs.add(Song.fromDb(map));
    }
    return songs;
  }

  Future<int> count() async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tbSongDetail'));
    if(count == null) return 0;
    return count;
  }

  Future<void> _insertCheck(String songId) async {
    _checkDuplicates(songId);
    int maxCount = Get.find<SettingsController>().getRecentsMaxLength;
    if(await count() == maxCount) _deleteFirstRow();
  }
  
  void _checkDuplicates(String songId) async {
    Database db = await _instance.database;
    await db.delete(tbSongDetail, where: '$colSongId = ?', whereArgs: [songId]);
  }

  void _deleteFirstRow() async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> rows = await db.query(tbSongDetail, limit: 1);
    int? firstRowId = rows.isNotEmpty ? rows.first['id'] : null;
    if (firstRowId != null) {
      await db.delete(tbSongDetail, where: 'id = ?', whereArgs: [firstRowId]);
    }
  }
}
