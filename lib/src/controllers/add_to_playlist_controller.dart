import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:sonicity/src/models/song.dart';

class AddToPlaylistController extends GetxController {
  final Song song;
  AddToPlaylistController(this.song);

  final db = GetIt.instance<MyPlaylistsDatabase>();
  final textController = TextEditingController();
  SettingsController settings = Get.find<SettingsController>();
  final playlists = <MyPlaylist>[].obs;
  final isSongPresent = <bool>[].obs;
  final dateCreated = <String>[].obs;
  final coverImages = <ImageUrl>[].obs;

  final playlistCount = (2).obs;

  @override
  void onInit() {
    super.onInit();
    initMethods();
  }

  Future<void> initMethods() async {
    await getPlaylistCount();
    await checkSongPresent();
    await getPlaylists();
  }

  Future<void> getPlaylists() async {
    playlists.value = await db.playlists;
    update();
  }
  
  Future<void> getPlaylistCount() async {
    playlistCount.value= await db.count();
    update();
  }
  
  Future<void> checkSongPresent() async {
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