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

  final playlistCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getPlaylists();
    getPlaylistCount();
  }

  void getPlaylists() async {
    List<Playlist> p =[];
    List<String> d = [];
    (p, d) = await db.details;

    playlists.value = p;
    dateCreated.value = d;
  }

  void newPlaylist() async {
    if(textController.text.isEmpty) return;
    await db.createPlaylist(textController.text);
    getPlaylistCount();
    getPlaylists();
  }

  void insertSong(String playlistName) async {
    db.insertSong(playlistName, song);
  }
  
  void getPlaylistCount() async {
    playlistCount.value = await db.count();
  }
}