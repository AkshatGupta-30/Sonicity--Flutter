import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class AllArtistsController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final selectedTab = 0.obs;
  
  final cloneDb = getIt<ClonedDatabase>();
  final starDb = getIt<StarredDatabase>();
  final isClone = false.obs;
  final isStar = false.obs;

  final cloneArtists = <Artist>[].obs;
  final starArtists = <Artist>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() => selectedTab.value = tabController.index);
    getAll();
  }

  void getAll() async {
    cloneArtists.value = await cloneDb.artists;
    starArtists.value = await starDb.artists;
  }

  void sortArtist(SortType sortType, Sort sortBy) {
    List<Artist> artistsToSort = (selectedTab.value == 0) ? starArtists : cloneArtists;
    Comparator<Artist>? comparator;
    switch (sortType) {
      case SortType.name:
        comparator = (sortBy == Sort.asc)
            ? (a, b) => a.name.compareTo(b.name)
            : (a, b) => b.name.compareTo(a.name);
        break;
      default:
        comparator = (sortBy == Sort.asc)
            ? (a, b) => a.description!.compareTo(b.description!)
            : (a, b) => b.description!.compareTo(a.description!);
    }
    artistsToSort.sort(comparator);
    update();
    }
}