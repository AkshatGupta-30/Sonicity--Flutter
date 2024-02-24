import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/services/search_artist_api.dart';

class ViewAllSearchArtistsController extends GetxController {
  final String searchText;
  ViewAllSearchArtistsController(this.searchText);

  final scrollController = ScrollController();
  final artists = <Artist>[].obs;
  int currentPage = 1;
  final artistCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCount(searchText);
    fetchArtists(searchText, 1);
    scrollController.addListener(() => _loadMore());
  }

  void fetchCount(String text) async {
    int fetchCount = await SearchArtistsApi.fetchCount(text);
    artistCount.value = fetchCount;
  }

  void _loadMore() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      currentPage++;
      fetchArtists(searchText, currentPage);
    }
    update();
  }

  void fetchArtists(String text, int page) async {
    List<Artist> fetchedList = await SearchArtistsApi.fetchData(text, page);
    artists.addAll(fetchedList);
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}