import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/top_query.dart';
import 'package:sonicity/src/services/search_api.dart';
import 'package:sonicity/src/sprefs/search_history.dart';

class SearchViewController extends GetxController {
  final searchController = TextEditingController();
  final historyList = <String>[].obs;
  final loading = false.obs;
  final searching = false.obs;
  final topQuery = TopQuery(songs: [], albums: [], artists: [], playlists: []).obs;

  @override
  void onInit() {
    super.onInit();
    initAsync();

    searchController.addListener(() {
      if(searchController.text.isEmpty) {
        loading.value = false;
        searching.value = false;
        topQuery.value.clear();
      }
      update();
    });
  }

  void initAsync() async {
    historyList.value = await SearchHistorySprefs.load();
    update();
  }

  void _searchText(text) async {
    loading.value = true;
    TopQuery top = await SearchViewApi.searchTopQuery(text);
    loading.value = false;
    topQuery.value = top;
    update();
  }

  void searchChanged(String text) {
  }

  void searchSubmitted(String text) {
    searching.value = true;
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
  }

  @override
  void onClose() {
    SearchHistorySprefs.save(historyList);
    searchController.dispose();
    super.onClose();
  }
}