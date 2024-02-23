import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/search_songs_api.dart';

class ViewAllSearchSongsController extends GetxController {
  final String searchText;
  ViewAllSearchSongsController(this.searchText);

  final scrollController = ScrollController();
  final songs = <Song>[].obs;
  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchSongs(searchText, 1);
    scrollController.addListener(() => _loadMore());
  }

  void _loadMore() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      currentPage++;
      fetchSongs(searchText, currentPage);
    }
    update();
  }

  void fetchSongs(String text, int page) async {
    List<Song> fetchedList = await SearchSongsApi.fetchData(text, page);
    songs.addAll(fetchedList);
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}