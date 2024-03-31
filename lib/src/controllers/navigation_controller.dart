import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/utils/contants/constants.dart';

class NavigationController extends GetxController with GetSingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;
  final selectedTab = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getIt<AudioManager>().init();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
  void closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }
}