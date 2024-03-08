import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/enums.dart';

class AddToPlaylistController extends GetxController {
  final Song song;
  AddToPlaylistController(this.song);

  final db = GetIt.instance<MyPlaylistsDatabase>();
  final textController = TextEditingController();
  SettingsController settings = Get.find<SettingsController>();
  final playlists = <MyPlaylist>[].obs;
  final isSongPresent = <bool>[].obs;
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

  void sort(SortType sortType, Sort sortBy) {
    final initialPlaylistIds = List<String>.from(playlists.map((playlist) => playlist.id));
    if(sortType == SortType.name) {
      if(sortBy == Sort.asc) {
        playlists.sort((a, b) => a.name.compareTo(b.name));
      } else{
        playlists.sort((a, b) => b.name.compareTo(a.name));
      }
    } else if(sortType == SortType.songCount) {
      if(sortBy == Sort.asc) {
        playlists.sort((a, b) => int.parse(a.songCount).compareTo(int.parse(b.songCount)));
      } else{
        playlists.sort((a, b) => int.parse(b.songCount).compareTo(int.parse(a.songCount)));
      }
    } else {
      if(sortBy == Sort.asc) {
        playlists.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
      } else{
        playlists.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
      }
    }
    final newPlaylistIds = List<String>.from(playlists.map((playlist) => playlist.id));
    final sortedIsSongPresent = List<bool>.generate(
      playlists.length, (index) => isSongPresent[initialPlaylistIds.indexOf(newPlaylistIds[index])]
    );
    isSongPresent.assignAll(sortedIsSongPresent);
    update();
  }
}