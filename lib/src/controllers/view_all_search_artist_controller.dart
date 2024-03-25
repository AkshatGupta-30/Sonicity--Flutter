import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/contants/constants.dart';

class ViewAllSearchArtistsController extends GetxController {
  final String searchText;
  ViewAllSearchArtistsController(this.searchText);

  final scrollController = ScrollController();
  final artists = <Artist>[].obs;
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
    int fetchCount = await SearchArtistsApi.fetchCount(text);
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
    List<Artist> fetchedList = await SearchArtistsApi.fetchData(text, page);
    artists.addAll(fetchedList);
    update();
  }

  void sort(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? artists.sort((a, b) => a.name.compareTo(b.name))
        : artists.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? artists.sort((a, b) => a.description!.compareTo(b.description!))
        : artists.sort((a, b) => b.description!.compareTo(a.description!));
    }
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}