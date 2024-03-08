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
  SettingsController settings = Get.find<SettingsController>();
  final playlists = <MyPlaylist>[].obs;
  final isSongPresent = <bool>[].obs;
  final playlistCount = (2).obs;

  final searching = false.obs;
  final searchResults = <MyPlaylist>[].obs;
  final searchIsSongPresent = <bool>[].obs;
  final searchPlaylistController = TextEditingController();
  FocusNode searchPlaylistFocus = FocusNode();

  final newPlaylistTextController = TextEditingController();
  FocusNode newPlaylistFocus = FocusNode();
  final newPlaylistTfActive = false.obs;

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

  Future<void> getPlaylists() async => playlists.value = await db.playlists;
  
  Future<void> getPlaylistCount() async => playlistCount.value= await db.count();
  
  Future<void> checkSongPresent() async => isSongPresent.value = await db.isSongPresent(song);

  void createPlaylist() async {
    if(newPlaylistTextController.text.isEmpty) return;
    await db.createPlaylist(newPlaylistTextController.text).then((value) => initMethods());
  }

  void insertSong(String playlistName) async => await db.insertSong(playlistName, song).then((value) => initMethods());

  void deleteSong(String playlistName) async => await db.deleteSong(playlistName, song).then((value) => initMethods());

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

  void filterSearchedPlaylists() {
    String query = searchPlaylistController.text;
    if (query.isEmpty) {
      searchResults.assignAll([]);
      searchIsSongPresent.assignAll([]);
      searching.value = false;
      return;
    }

    searching.value = true;
    final filteredPlaylists = <MyPlaylist>[];
    final filteredIsSongPresent = <bool>[];
    for (int i = 0; i < playlists.length; i++) {
      if (playlists[i].name.toLowerCase().contains(query.toLowerCase())) {
        filteredPlaylists.add(playlists[i]);
        filteredIsSongPresent.add(isSongPresent[i]);
      }
    }
    searchResults.assignAll(filteredPlaylists);
    searchIsSongPresent.assignAll(filteredIsSongPresent);
  }
}