import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/enums.dart';

class RecentsController extends GetxController with GetTickerProviderStateMixin {
  final _recentDatabase = GetIt.instance<RecentsDatabase>();
  late TabController tabController;
  final selectedTab = 0.obs;
  final recentSongs = <Song>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getSongs();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() => selectedTab.value = tabController.index);
  }

  void _getSongs() async {
    recentSongs.value = await _recentDatabase.getAll();
  }

  void sortSongs(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => a.name.compareTo(b.name))
        : recentSongs.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : recentSongs.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => a.year!.compareTo(b.year!))
        : recentSongs.sort((a, b) => b.year!.compareTo(a.year!));
    }
    update();
  }

  void sortAlbums(SortType sortType, Sort sortBy) {}
  void sortArtists(SortType sortType, Sort sortBy) {}
  void sortPlaylists(SortType sortType, Sort sortBy) {}
}