import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/hot_playlists.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/src/models/top_charts.dart';
import 'package:sonicity/src/models/trending_now.dart';
import 'package:sonicity/src/services/home_view_api.dart';

class HomeViewController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final selectedTab = 0.obs;
  final trendingNow  = TrendingNow.empty().obs;
  final topCharts = TopCharts.empty().obs;
  final topAlbums = TopAlbums.empty().obs;
  final hotPlaylists = HotPlaylists.empty().obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
    getHomeData();
  }

  void getHomeData() async {
    TrendingNow tN  = TrendingNow.empty();
    TopCharts tC = TopCharts.empty();
    TopAlbums tA = TopAlbums.empty();
    HotPlaylists hP = HotPlaylists.empty();
    (tN, tC, tA, hP) = await HomeViewApi.get();

    trendingNow.value = tN;
    topCharts.value = tC;
    topAlbums.value = tA;
    hotPlaylists.value = hP;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}