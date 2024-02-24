import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/view_all_search_album_controller.dart';
import 'package:sonicity/src/controllers/view_all_search_artist_controller.dart';
import 'package:sonicity/src/controllers/view_all_search_playlist_controller.dart';
import 'package:sonicity/src/controllers/view_all_search_song_controller.dart';
import 'package:sonicity/src/models/search_all.dart';
import 'package:sonicity/src/services/search_all_api.dart';
import 'package:sonicity/src/sprefs/search_history.dart';

class SearchViewController extends GetxController {
  final searchController = TextEditingController();
  final historyList = <String>[].obs;
  final loading = false.obs;
  final searching = false.obs;
  final searchAll = SearchAll(
    topQuery: TopQuery(songs: [], albums: [], artists: [], playlists: []),
    songs: [], albums: [], artists: [], playlists: []
  ).obs;

  @override
  void onInit() {
    super.onInit();
    initAsync();

    searchController.addListener(() {
      if(searchController.text.isEmpty) {
        loading.value = false;
        searching.value = false;
        searchAll.value.clear();
        _deleteControllersIfExists();
      }
      update();
    });
  }

  void initAsync() async {
    historyList.value = await SearchHistorySprefs.load();
    update();
  }

  void _deleteControllersIfExists() {
  if (Get.isRegistered<ViewAllSearchSongsController>()) {
    Get.delete<ViewAllSearchSongsController>();
  }
  if (Get.isRegistered<ViewAllSearchAlbumsController>()) {
    Get.delete<ViewAllSearchAlbumsController>();
  }
  if (Get.isRegistered<ViewAllSearchArtistsController>()) {
    Get.delete<ViewAllSearchArtistsController>();
  }
  if (Get.isRegistered<ViewAllSearchPlaylistsController>()) {
    Get.delete<ViewAllSearchPlaylistsController>();
  }
}

  void _searchText(text) async {
    loading.value = true;
    SearchAll search = await SearchAllApi.searchAll(text);
    loading.value = false;
    searchAll.value = search;
    update();
  }

  void searchChanged(String text) {
  }

  void searchSubmitted(String text) {
    searching.value = true;
    _searchText(text);
    Get.put(ViewAllSearchSongsController(searchController.text));
    Get.put(ViewAllSearchAlbumsController(searchController.text));
    Get.put(ViewAllSearchArtistsController(searchController.text));
    Get.put(ViewAllSearchPlaylistsController(searchController.text));
    if(historyList.contains(text)) {
      historyList.remove(text);
    }
    historyList.insert(0, text);
    if(historyList.length > 20) {
      historyList.removeAt(21);
    }
    SearchHistorySprefs.save(historyList);
    update();
  }

  void chipRemoved(int index) {
    historyList.removeAt(index);
    update();
  }

  void chipTapped(int index) {
    searchController.text = historyList[index];
    searchSubmitted(searchController.text);
  }

  @override
  void onClose() {
    SearchHistorySprefs.save(historyList);
    searchController.dispose();
    super.onClose();
  }
}