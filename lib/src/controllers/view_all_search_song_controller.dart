import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/search_songs_api.dart';
import 'package:sonicity/utils/contants/enums.dart';

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

  void sort(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? songs.sort((a, b) => a.name.compareTo(b.name))
        : songs.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? songs.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : songs.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? songs.sort((a, b) => a.year!.compareTo(b.year!))
        : songs.sort((a, b) => b.year!.compareTo(a.year!));
    }
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}