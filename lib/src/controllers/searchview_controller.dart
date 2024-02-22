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
      } else {
        loading.value = true;
      }
      update();
    });
  }

  void initAsync() async {
    historyList.value = await SearchHistorySprefs.load();
  }

  void _searchText(text) async {
    TopQuery top = await SearchViewApi.searchTopQuery(text);
    topQuery.value = top;
    update();
  }

  void searchChanged(String text) {
    _searchText(text);
  }

  void searchSubmitted(String text) {
    if(historyList.contains(text)) {
      historyList.remove(text);
    }
    historyList.insert(0, text);
    if(historyList.length > 20) {
      historyList.removeAt(21);
    }
    SearchHistorySprefs.save(historyList);
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