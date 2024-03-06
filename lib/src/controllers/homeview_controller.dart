import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonicity/src/database/home_database.dart';
import 'package:sonicity/src/models/hot_playlists.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/src/models/top_charts.dart';
import 'package:sonicity/src/models/trending_now.dart';
import 'package:sonicity/src/services/home_view_api.dart';
import 'package:sonicity/utils/contants/prefs_keys.dart';

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
    GetIt.I.registerSingleton<HomeDatabase>(HomeDatabase());
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
    getHomeData(false);
    checkInstanceTimer();
  }

  void checkInstanceTimer() async {
    final prefs = await SharedPreferences.getInstance();
    int lastExecutionTimeMillis = prefs.getInt(PrefsKey.homeExecutionTime) ?? 0;
    DateTime lastExecutionTime = DateTime.fromMillisecondsSinceEpoch(lastExecutionTimeMillis);
    Duration timeDifference = DateTime.now().difference(lastExecutionTime);
    if (timeDifference.inMinutes >= 30 || lastExecutionTime.day != DateTime.now().day) {
      getHomeData(true);
      prefs.setInt(PrefsKey.homeExecutionTime, DateTime.now().millisecondsSinceEpoch);
    }

    Timer.periodic(Duration(minutes: 30), (Timer timer) {
      getHomeData(false);
      prefs.setInt(PrefsKey.homeExecutionTime, DateTime.now().millisecondsSinceEpoch);
    });
  }

  void getHomeData(bool needInstant) async {
    TrendingNow tN  = TrendingNow.empty();
    TopCharts tC = TopCharts.empty();
    TopAlbums tA = TopAlbums.empty();
    HotPlaylists hP = HotPlaylists.empty();

    final homeDatabase = GetIt.instance<HomeDatabase>();
    if(needInstant || !(await homeDatabase.isFilled())) {
      (tN, tC, tA, hP) = await HomeViewApi.get();
      trendingNow.value = tN;
      topCharts.value = tC;
      topAlbums.value = tA;
      hotPlaylists.value = hP;

      homeDatabase.clearAll();
      await homeDatabase.insertData(trendNow: tN, tpChart: tC, tpAlbum: tA, htPlaylist: hP);
    } else {
      tN = await homeDatabase.trending; trendingNow.value = tN;
      tC = await homeDatabase.topCharts; topCharts.value = tC;
      tA = await homeDatabase.topAlbums; topAlbums.value = tA;
      hP = await homeDatabase.hotPlaylist; hotPlaylists.value = hP;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}