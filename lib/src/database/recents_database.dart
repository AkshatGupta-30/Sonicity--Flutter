import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
import 'package:sonicity/utils/sections/download_url_section.dart';
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
  static const tbSongArtists = 'song_artists';
  static const tbSongLowImgs = 'song_low_img';
  static const tbSongMedImgs = 'song_med_img';
  static const tbSongHighImgs = 'song_high_img';
  static const tbSongQ12kbpsDownloadQuality = 'song_12_download_quality';
  static const tbSongQ48kbpsDownloadQuality = 'song_48_download_quality';
  static const tbSongQ96kbpsDownloadQuality = 'song_96_download_quality';
  static const tbSongQ160kbpsDownloadQuality = 'song_160_download_quality';
  static const tbSongQ320kbpsDownloadQuality = 'song_320_download_quality';

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
  static const colLink = 'link';
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
    await db.execute("CREATE TABLE $tbSongLowImgs ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongMedImgs ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongHighImgs ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");

    await db.execute("CREATE TABLE $tbSongQ12kbpsDownloadQuality ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongQ48kbpsDownloadQuality ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongQ96kbpsDownloadQuality ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongQ160kbpsDownloadQuality ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");
    await db.execute("CREATE TABLE $tbSongQ320kbpsDownloadQuality ($colSongId TEXT NOT NULL, $colLink TEXT NOT NULL)");
  }

  Future<int> insert(Song song) async {
    Database db = await _instance.database;
    // * Images
    await db.insert(tbSongLowImgs, song.toDbImgsMap(ImgQuality.low));
    await db.insert(tbSongMedImgs, song.toDbImgsMap(ImgQuality.med));
    await db.insert(tbSongHighImgs, song.toDbImgsMap(ImgQuality.high));

    // * Download Quality
    await db.insert(tbSongQ12kbpsDownloadQuality, song.toDbDownloadloadsMap(DownloadQuality.q12kbps));
    await db.insert(tbSongQ48kbpsDownloadQuality, song.toDbDownloadloadsMap(DownloadQuality.q48kbps));
    await db.insert(tbSongQ96kbpsDownloadQuality, song.toDbDownloadloadsMap(DownloadQuality.q96kbps));
    await db.insert(tbSongQ160kbpsDownloadQuality, song.toDbDownloadloadsMap(DownloadQuality.q160kbps));
    await db.insert(tbSongQ320kbpsDownloadQuality, song.toDbDownloadloadsMap(DownloadQuality.q320kbps));

    // * Details
    return await db.insert(tbSongDetail, song.toDbDetailsMap());
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await _instance.database;
    return await db.query(tbSongDetail);
  }

  Future<int> count() async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tbSongDetail'));
    if(count == null) return 0;
    return count;
  }
}
