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
  final focusNode = FocusNode();
  final historyList = <String>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;
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
        isLoading.value = false;
        isSearching.value = false;
        searchAll.value.clear();
        _closeControllers();
      }
      update();
    });
  }

  void initAsync() async {
    historyList.value = await SearchHistorySprefs.load();
    update();
  }

  void _searchText(text) async {
    isLoading.value = true;
    SearchAll search = await SearchAllApi.searchAll(text);
    isLoading.value = false;
    searchAll.value = search;
    update();
  }

  void searchChanged(String text) {
  }

  void searchSubmitted(String text) {
    focusNode.unfocus();
    isSearching.value = true;
    _searchText(text);
    if(historyList.contains(text)) {
      historyList.remove(text);
    }
    historyList.insert(0, text);
    if(historyList.length > 20) {
      historyList.removeAt(21);
    }
    SearchHistorySprefs.save(historyList);
    _initControllers();
    update();
  }

  void _initControllers() {
    Get.lazyPut(() => ViewAllSearchSongsController(searchController.text));
    Get.lazyPut(() => ViewAllSearchAlbumsController(searchController.text));
    Get.lazyPut(() => ViewAllSearchArtistsController(searchController.text));
    Get.lazyPut(() => ViewAllSearchPlaylistsController(searchController.text));
  }

  void _closeControllers() {
    if(Get.isRegistered<ViewAllSearchSongsController>()) {
      Get.delete<ViewAllSearchSongsController>();
    }
    if(Get.isRegistered<ViewAllSearchAlbumsController>()) {
      Get.delete<ViewAllSearchAlbumsController>();
    }
    if(Get.isRegistered<ViewAllSearchArtistsController>()) {
      Get.delete<ViewAllSearchArtistsController>();
    }
    if(Get.isRegistered<ViewAllSearchPlaylistsController>()) {
      Get.delete<ViewAllSearchPlaylistsController>();
    }
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