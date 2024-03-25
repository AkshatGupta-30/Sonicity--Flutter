import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/contants/constants.dart';

class ViewAllSearchAlbumsController extends GetxController {
  final String searchText;
  ViewAllSearchAlbumsController(this.searchText);

  final scrollController = ScrollController();
  final albums = <Album>[].obs;
  int currentPage = 1;
  final albumCount = 0.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCount(searchText);
    fetchAlbums(searchText, 1);
    scrollController.addListener(_loadMore);
  }

  void fetchCount(String text) async {
    int fetchCount = await SearchAlbumsApi.fetchCount(text);
    albumCount.value = fetchCount;
    update();
  }

  Future<void> _loadMore() async {
    if(isLoadingMore.value) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      currentPage++;
      await fetchAlbums(searchText, currentPage).then((value) => isLoadingMore.value = false);
    }
    update();
  }

  Future<void> fetchAlbums(String text, int page) async {
    List<Album> fetchedList = await SearchAlbumsApi.fetchData(text, page);
    albums.addAll(fetchedList);
    update();
  }

  void sort(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? albums.sort((a, b) => a.name.compareTo(b.name))
        : albums.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? albums.sort((a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!)))
        : albums.sort((a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!)));
    }
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}