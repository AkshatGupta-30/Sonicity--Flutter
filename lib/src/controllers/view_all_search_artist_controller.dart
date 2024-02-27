import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/services/new_search_artist_api.dart';

class ViewAllSearchArtistsController extends GetxController {
  final String searchText;
  ViewAllSearchArtistsController(this.searchText);

  final scrollController = ScrollController();
  final artists = <NewArtist>[].obs;
  int currentPage = 1;
  final artistCount = 0.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCount(searchText);
    fetchArtists(searchText, 1);
    scrollController.addListener(_loadMore);
  }

  void fetchCount(String text) async {
    int fetchCount = await NewSearchArtistsApi.fetchCount(text);
    artistCount.value = fetchCount;
  }

  Future<void> _loadMore() async {
    if(isLoadingMore.value) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      currentPage++;
      await fetchArtists(searchText, currentPage).then((value) => isLoadingMore.value = false);
    }
    update();
  }

  Future<void> fetchArtists(String text, int page) async {
    List<NewArtist> fetchedList = await NewSearchArtistsApi.fetchData(text, page);
    artists.addAll(fetchedList);
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}