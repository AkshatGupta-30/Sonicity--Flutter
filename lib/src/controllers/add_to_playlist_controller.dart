import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';

class AddToPlaylistController extends GetxController {
  final Song song;
  AddToPlaylistController(this.song);

  final db = GetIt.instance<MyPlaylistsDatabase>();
  final textController = TextEditingController();
  SettingsController settings = Get.find<SettingsController>();
  final playlists = <Playlist>[].obs;
  final dateCreated = <String>[].obs;
  final isSongPresent = <bool>[].obs;

  final playlistCount = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    initMethods();
  }

  void initMethods() {
    getPlaylists();
    getPlaylistCount();
    checkSongPresent();
  }

  void getPlaylists() async {
    List<Playlist> p =[];
    List<String> d = [];
    (p, d) = await db.playlists;

    playlists.value = p;
    dateCreated.value = d;
    update();
  }
  
  void getPlaylistCount() async {
    playlistCount.value= await db.count();
    update();
  }
  
  void checkSongPresent() async {
    isSongPresent.value = await db.isSongPresent(song);
    update();
  }

  void createPlaylist() async {
    if(textController.text.isEmpty) return;
    await db.createPlaylist(textController.text).then((value) => initMethods());
  }

  void insertSong(String playlistName) async {
    await db.insertSong(playlistName, song).then((value) => initMethods());
  }

  void deleteSong(String playlistName) async {
    await db.deleteSong(playlistName, song).then((value) => initMethods());
  }
}