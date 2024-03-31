import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class AllSongsController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final selectedTab = 0.obs;
  
  final cloneDb = getIt<ClonedDatabase>();
  final starDb = getIt<StarredDatabase>();
  final isClone = false.obs;
  final isStar = false.obs;

  final cloneSongs = <Song>[].obs;
  final starSongs = <Song>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() => selectedTab.value = tabController.index);
    getAll();
  }

  void getAll() async {
    cloneSongs.value = await cloneDb.songs;
    starSongs.value = await starDb.songs;
  }

  void sortSongs(SortType sortType, Sort sortBy) {
    List<Song> songsToSort = (selectedTab.value == 0) ? starSongs : cloneSongs;
    Comparator<Song>? comparator;
    switch (sortType) {
      case SortType.name:
        comparator = (sortBy == Sort.asc)
            ? (a, b) => a.name.compareTo(b.name)
            : (a, b) => b.name.compareTo(a.name);
        break;
      case SortType.year:
        comparator = (sortBy == Sort.asc)
            ? (a, b) => a.year!.compareTo(b.year!)
            : (a, b) => b.year!.compareTo(a.year!);
        break;
      default:
        comparator = (sortBy == Sort.asc)
            ? (a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!))
            : (a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!));
    }
    songsToSort.sort(comparator);
    update();
    }
}