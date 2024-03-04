import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
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
  static const tbSongLowImgs = 'song_low_img';
  static const tbSongMedImgs = 'song_med_img';
  static const tbSongHighImgs = 'song_high_img';

  static const colId = 'id';
  static const colSongId = 'song_id';
  static const colName = 'name';
  static const colHasLyrics = 'hasLyrics';
  static const colYear = 'year';
  static const colReleaseDate = 'releaseDate';
  static const colDuration = 'duration';
  static const colLanguage = 'language';
  static const colImgLink = 'link';
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $tbSongDetail (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colSongId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colHasLyrics INTEGER,
          $colYear TEXT,
          $colReleaseDate TEXT,
          $colDuration TEXT,
          $colLanguage TEXT
        )
      '''
    );
    await db.execute("CREATE TABLE $tbSongLowImgs ($colSongId TEXT NOT NULL, $colImgLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongMedImgs ($colSongId TEXT NOT NULL, $colImgLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongHighImgs ($colSongId TEXT NOT NULL, $colImgLink TEXT NOT NULL)");
  }

  Future<int> insert(Song song) async {
    Database db = await _instance.database;
    jsonEncode(song.toDbDetailsMap()).toString().printInfo();
    await db.insert(tbSongLowImgs, song.toDbImgsMap(ImgQuality.low));
    await db.insert(tbSongMedImgs, song.toDbImgsMap(ImgQuality.med));
    await db.insert(tbSongHighImgs, song.toDbImgsMap(ImgQuality.high));
    return await db.insert(tbSongDetail, song.toDbDetailsMap());
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await _instance.database;
    return await db.query(tbSongHighImgs);
  }

  Future<int> count() async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tbSongDetail'));
    if(count == null) return 0;
    return count;
  }
}
