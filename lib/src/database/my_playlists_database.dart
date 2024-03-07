// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sqflite/sqflite.dart';

class MyPlaylistsDatabase {
  MyPlaylistsDatabase._();
  static final MyPlaylistsDatabase _instance = MyPlaylistsDatabase._();
  factory MyPlaylistsDatabase() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const _databaseName = "my_playlists.db";
  static const _databaseVersion = 1;
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}$_databaseName";
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  static const tbPlaylistDetails = 'playlist_details';

  static const colPlaylistId = 'playlist_id';
  static const colName = 'name';
  static const colDateCreated = 'date_created';
  static const colSongCount = 'songCount';
  static const colImg1 = 'img_1';
  static const colImg2 = 'img_2';
  static const colImg3 = 'img_3';
  static const colImg4 = 'img_4';
  static const colSongIds = 'song_ids';
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $tbPlaylistDetails (
          $colPlaylistId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colName TEXT NOT NULL,
          $colDateCreated TEXT NOT NULL,
          $colSongCount INTEGER NOT NULL,
          $colSongIds TEXT
        )
      '''
    );
  }

  static const colSongId = 'song_id';
  static const colAlbumId = 'album_id';
  static const colAlbumName = 'album_name';
  static const colArtistIds = 'artist_ids';
  static const colArtistNames = 'artist_names';
  static const colHasLyrics = 'hasLyrics';
  static const colYear = 'year';
  static const colReleaseDate = 'releaseDate';
  static const colDuration = 'duration';
  static const colLanguage = 'language';
  static const colDominantType = 'dominantType';
  static const colImgLow = 'img_low';
  static const colImgMed = 'img_med';
  static const colImgHigh = 'img_high';
  static const colDownload12kbps = 'download_12kbps';
  static const colDownload48kbps = 'download_48kbps';
  static const colDownload96kbps = 'download_96kbps';
  static const colDownload160kbps = 'download_160kbps';
  static const colDownload320kbps = 'download_320kbps';
  Future createPlaylist(String playlistName) async {
    Database db = await _instance.database;
    await db.execute(// * Create playlist
      '''
        CREATE TABLE ${playlistName.replaceAll(' ', '_')} (
          $colPlaylistId INTEGER PRIMARY KEY AUTOINCREMENT,
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
    await db.insert(
      tbPlaylistDetails,
      {
        colName : playlistName.replaceAll(' ', '_'),
        colDateCreated : DateTime.now().toIso8601String(),
        colSongCount : 0,
        colSongIds: "" 
      }
    );
  }

  void deletePlaylist(String playlistName) async {
    Database db = await _instance.database;
    await db.delete(tbPlaylistDetails, where: "$colName = ?", whereArgs: [playlistName.replaceAll(' ', '_')]);
    await db.delete(playlistName.replaceAll(' ', '_'));
  }

  Future<(List<Playlist>, List<String>)> get playlists async {
    Database db = await _instance.database;
    List<Playlist> playlists = []; List<String> dateCreated = [];
    List<Map<String,dynamic>> playlistResult = await db.query(tbPlaylistDetails);
    for (var map in playlistResult) {
      playlists.add(Playlist(
        id: map[colPlaylistId].toString(),
        name: map[colName],
        songCount: map[colSongCount].toString(),
        language: map[colLanguage],
        image: ImageUrl.empty()
      ));
      dateCreated.add(map[colDateCreated]);
    }
    return (playlists, dateCreated);
  }

  Future<List<Song>> getSongs(String playlistName) async {
    Database db = await _instance.database;
    List<Song> songs = [];
    List<Map<String,dynamic>> songsResult = await db.query(playlistName.replaceAll(' ', '_'));
    for (var map in songsResult) {
      songs.add(Song.fromDb(map));
    }
    return songs;
  }

  Future<void> insertSong(String playlistName, Song song) async {
    Database db = await _instance.database;
    playlistName = playlistName.replaceAll(" ", "_");
    await db.insert(
      playlistName,
      song.toDb()
    ).then((value) async => await updateSongIdsInMain(playlistName, song, isInsert: true));
  }

  Future<void> deleteSong(String playlistName, Song song) async {
    Database db = await _instance.database;
    await db.delete(
      playlistName.replaceAll(' ', '_'),
      where: "$colSongId = ?",
      whereArgs: [song.id]
    ).then((value) async => await updateSongIdsInMain(playlistName, song, isInsert: false));
  }

  Future<void> updateSongIdsInMain(String playlistName, Song song, {required bool isInsert}) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> result = await db.query(tbPlaylistDetails,
      columns: [colSongIds],
      where: '$colName = ?',
      whereArgs: [playlistName]);
    String existingIds = (result.isNotEmpty) ? result.first[colSongIds] : '';

    if (isInsert && !existingIds.contains(song.id)) {
      String updatedIds = existingIds.isEmpty ? song.id.toString() : '$existingIds,${song.id}';
      await db.rawUpdate(
        '''
          UPDATE $tbPlaylistDetails 
          SET $colSongCount = $colSongCount + 1, $colSongIds = ? 
          WHERE $colName = ?
        ''',
        [updatedIds, playlistName]
      );
    } else if (!isInsert && existingIds.contains(song.id.toString())) {
      String updatedIds = existingIds.replaceFirst(',${song.id}', '').replaceAll(song.id.toString(), '');
      await db.rawUpdate(
        '''
          UPDATE $tbPlaylistDetails 
          SET $colSongCount = $colSongCount - 1, $colSongIds = ? 
          WHERE $colName = ?
        ''',
        [updatedIds, playlistName]
      );
    }
  }

  Future<List<bool>> isSongPresent(Song song) async {
    final db = await _instance.database;
    List<bool> songTrue = [];
    List<Map<String,dynamic>> songIds = await db.query(tbPlaylistDetails, columns: [colSongIds]);
    for (int i=0; i<songIds.length; i++) {
      bool isPresent = (songIds[i][colSongIds] == song.id);
      songTrue.add(isPresent);
    }
    return songTrue;
  }

  Future<int> count() async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tbPlaylistDetails'));
    if(count == null) return 0;
    return count;
  }
}
