import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/services/search_playlist_api.dart';
import 'package:sonicity/utils/contants/enums.dart';

class ViewAllSearchPlaylistsController extends GetxController {
  final String searchText;
  ViewAllSearchPlaylistsController(this.searchText);

  final scrollController = ScrollController();
  final playlists = <Playlist>[].obs;
  int currentPage = 1;
  final playlistCount = 0.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCount(searchText);
    fetchPlaylists(searchText, 1);
    scrollController.addListener(_loadMore);
  }

  void fetchCount(String text) async {
    int fetchCount = await SearchPlaylistsApi.fetchCount(text);
    playlistCount.value = fetchCount;
  }

  Future<void> _loadMore() async {
    if(isLoadingMore.value) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      currentPage++;
      await fetchPlaylists(searchText, currentPage).then((value) => isLoadingMore.value = false);
    }
    update();
  }

  Future<void> fetchPlaylists(String text, int page) async {
    List<Playlist> fetchedList = await SearchPlaylistsApi.fetchData(text, page);
    playlists.addAll(fetchedList);
    update();
  }

  void sort(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? playlists.sort((a, b) => a.name.compareTo(b.name))
        : playlists.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? playlists.sort((a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!)))
        : playlists.sort((a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!)));
    }
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}