import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class AllAlbumsController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final selectedTab = 0.obs;
  
  final cloneDb = GetIt.instance<ClonedDatabase>();
  final starDb = GetIt.instance<StarredDatabase>();
  final isClone = false.obs;
  final isStar = false.obs;

  final cloneAlbums = <Album>[].obs;
  final starAlbums = <Album>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() => selectedTab.value = tabController.index);
    getAll();
  }

  void getAll() async {
    cloneAlbums.value = await cloneDb.albums;
    starAlbums.value = await starDb.albums;
  }

  void sortAlbums(SortType sortType, Sort sortBy) {
    List<Album> albumsToSort = (selectedTab.value == 0) ? starAlbums : cloneAlbums;
    Comparator<Album>? comparator;
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
    albumsToSort.sort(comparator);
    update();
    }
}