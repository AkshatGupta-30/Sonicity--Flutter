import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/contants/constants.dart';

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
    getHomeData(false);
    checkInstanceTimer();
  }

  void checkInstanceTimer() async {
    final prefs = await SharedPreferences.getInstance();
    int lastExecutionTimeMillis = prefs.getInt(PrefsKey.homeExecutionTime) ?? 0;
    DateTime lastExecutionTime = DateTime.fromMillisecondsSinceEpoch(lastExecutionTimeMillis);
    Duration timeDifference = DateTime.now().difference(lastExecutionTime);
    int maxTime = 100000; // ! = 30
    if (timeDifference.inMinutes >= maxTime || lastExecutionTime.day != DateTime.now().day) {
      getHomeData(true);
      prefs.setInt(PrefsKey.homeExecutionTime, DateTime.now().millisecondsSinceEpoch);
    }

    Timer.periodic(Duration(minutes: maxTime), (Timer timer) {
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