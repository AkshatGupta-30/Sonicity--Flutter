import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/services/search_albums_api.dart';

class ViewAllSearchAlbumsController extends GetxController {
  final String searchText;
  ViewAllSearchAlbumsController(this.searchText);

  final scrollController = ScrollController();
  final albums = <Album>[].obs;
  int currentPage = 1;
  final albumCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlbums(searchText, 1);
    scrollController.addListener(() => _loadMore());
  }

  void _loadMore() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      currentPage++;
      fetchAlbums(searchText, currentPage);
    }
    update();
  }

  void fetchAlbums(String text, int page) async {
        List<Album> fetchedList = await SearchAlbumsApi.fetchData(text, page);
    albums.addAll(fetchedList);
    int fetchCount = await SearchAlbumsApi.fetchCount(text);
    albumCount.value = fetchCount;
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}