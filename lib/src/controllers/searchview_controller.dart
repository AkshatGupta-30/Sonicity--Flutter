import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/sprefs/search_history.dart';

class SearchViewController extends GetxController {
  final searchController = TextEditingController();
  final historyList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initAsync();
  }

  void initAsync() async {
    historyList.value = await SearchHistorySprefs.load();
  }

  void searchChanged(String text) {}

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