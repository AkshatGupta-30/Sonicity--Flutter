import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/search_all.dart';
import 'package:sonicity/src/services/search_all_api.dart';
import 'package:sonicity/src/sprefs/search_history.dart';

class SearchViewController extends GetxController {
  final searchController = TextEditingController();
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