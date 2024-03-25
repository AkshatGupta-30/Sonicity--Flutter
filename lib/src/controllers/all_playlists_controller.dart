import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class AllPlaylistsController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final selectedTab = 0.obs;
  
  final cloneDb = getIt<ClonedDatabase>();
  final starDb = getIt<StarredDatabase>();
  final isClone = false.obs;
  final isStar = false.obs;

  final clonePlaylists = <Playlist>[].obs;
  final starPlaylists = <Playlist>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() => selectedTab.value = tabController.index);
    getAll();
  }

  void getAll() async {
    clonePlaylists.value = await cloneDb.playlists;
    starPlaylists.value = await starDb.playlists;
  }

  void sortPlaylists(SortType sortType, Sort sortBy) {
    List<Playlist> playlistsToSort = (selectedTab.value == 0) ? starPlaylists : clonePlaylists;
    Comparator<Playlist>? comparator;
    switch (sortType) {
      case SortType.name:
        comparator = (sortBy == Sort.asc)
            ? (a, b) => a.name.compareTo(b.name)
            : (a, b) => b.name.compareTo(a.name);
        break;
      default:
        comparator = (sortBy == Sort.asc)
            ? (a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!))
            : (a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!));
    }
    playlistsToSort.sort(comparator);
    update();
    }
}