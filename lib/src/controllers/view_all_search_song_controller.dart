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
  final songCount = 0.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCount(searchText);
    fetchSongs(searchText, 1);
    scrollController.addListener(_loadMore);
  }

  Future<void> _loadMore() async {
    if(isLoadingMore.value) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      currentPage++;
      await fetchSongs(searchText, currentPage).then((value) => isLoadingMore.value = false);
    }
    update();
  }

  void fetchCount(String text) async {
    int fetchCount = await SearchSongsApi.fetchCount(text);
    songCount.value = fetchCount;
  }

  Future<void> fetchSongs(String text, int page) async {
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