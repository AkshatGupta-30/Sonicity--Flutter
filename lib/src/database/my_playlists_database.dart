// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
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

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $tbPlaylistDetails (
          $colPlaylistId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colName TEXT NOT NULL,
          $colDateCreated TEXT NOT NULL,
          $colSongCount INTEGER NOT NULL,
          $colSongIds TEXT,
          $colImages TEXT
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
        colSongIds : "" ,
        colImages : defaultImg
      }
    );
  }

  Future<void> deletePlaylist(String playlistName) async {
    Database db = await _instance.database;
    await db.delete(tbPlaylistDetails, where: "$colName = ?", whereArgs: [playlistName.replaceAll(' ', '_')]);
    await db.execute('DROP TABLE IF EXISTS ${playlistName.replaceAll(' ', '_')}');
  }

  Future<void> renamePlaylist(String playlistName, String newName) async {
    final db = await _instance.database;
    await db.update(
      tbPlaylistDetails,
      {colName: newName},
      where: '$colName = ?',
      whereArgs: [playlistName.replaceAll(' ', '_')]
    );
    await db.execute('ALTER TABLE ${playlistName.replaceAll(' ', '_')} RENAME TO $newName');
  }

  Future<List<MyPlaylist>> get playlists async {
    Database db = await _instance.database;
    List<MyPlaylist> playlists = [];
    List<Map<String,dynamic>> playlistResult = await db.query(tbPlaylistDetails);
    for (var map in playlistResult) {
      playlists.add(MyPlaylist.fromDb(map));
    }
    return playlists;
  }

  Future<void> mergePlaylist(List<String> playlistsNameList) async {
    Database db = await _instance.database;
    String mergedName = 'merge_${playlistsNameList.join('_')}';

    await createPlaylist(mergedName);

    for (var playlistName in playlistsNameList) {
      List<Map<String, dynamic>> table = await db.query(playlistName);
      for (Map<String, dynamic> row in table) {
        await insertSong(mergedName, Song.fromDb(row));
      }
    }
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
    final res = await db.query(playlistName, columns: [colSongId], where: "$colSongId = ?", whereArgs: [song.id]);
    if(res.isNotEmpty) return;
    await db.insert(
      playlistName,
      song.toDb()
    ).then((value) async => await updateInMain(playlistName, song, isInsert: true));
  }

  Future<void> deleteSong(String playlistName, Song song) async {
    Database db = await _instance.database;
    playlistName = playlistName.replaceAll(" ", "_");
    final res = await db.query(playlistName, columns: [colSongId], where: "$colSongId = ?", whereArgs: [song.id]);
    if(res.isEmpty) return;
    await db.delete(
      playlistName,
      where: "$colSongId = ?",
      whereArgs: [song.id]
    ).then((value) async => await updateInMain(playlistName, song, isInsert: false));
  }

  Future<void> updateInMain(String playlistName, Song song, {required bool isInsert}) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> result = await db.query(tbPlaylistDetails,
      columns: [colSongIds, colImages],
      where: '$colName = ?',
      whereArgs: [playlistName],
    );

    // * Song Ids
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
    // * Images
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${playlistName.replaceAll(' ', '_')}'))!;
    if(count < 4) {
      if(isInsert) {
        String imageLinks = '${song.image.lowQuality}$specCharQuality${song.image.medQuality}$specCharQuality${song.image.highQuality}';
        if(count <= 4) {
          String existingImages = (result.isNotEmpty) ? result.first[colImages] : '';
          String appendImage = "$existingImages$specCharSong$imageLinks";
          await db.update(
            tbPlaylistDetails,
            {colImages : appendImage},
            where: '$colName = ?',
            whereArgs: [playlistName]
          );
        }
      } else {
        if(count == 0) {
          await db.update(
            tbPlaylistDetails,
            {colImages : defaultImg},
            where: '$colName = ?',
            whereArgs: [playlistName]
          );
        } else {
          String imageLinks = '${song.image.lowQuality}$specCharQuality${song.image.medQuality}$specCharQuality${song.image.highQuality}';
          String existingImages = (result.isNotEmpty) ? result.first[colImages] : '';
          String newImages = existingImages.replaceFirst("$specCharSong$imageLinks", "");
          await db.update(
            tbPlaylistDetails,
            {colImages: newImages},
            where: '$colName = ?',
            whereArgs: [playlistName]
          );
        }
      }
    } else {
      return;
    }
  }

  Future<List<bool>> isSongPresent(Song song) async {
    final db = await _instance.database;
    List<bool> isSongPresent = [];
    List<Map<String,dynamic>> queryRes = await db.query(tbPlaylistDetails, columns: [colSongIds]);
    if(queryRes.isEmpty) return [];
    for(var songId in queryRes) {
      if(songId[colSongIds].toString().contains(song.id)) {
        isSongPresent.add(true);
      } else {
        isSongPresent.add(false);
      }
    }
    return isSongPresent;
  }

  Future<int> get playlistCount async {
    Database db = await _instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tbPlaylistDetails'));
    if(count == null) return 0;
    return count;
  }
}
