import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/new_home.dart';
import 'package:sonicity/src/services/new_home_view_api.dart';

class HomeViewController extends GetxController with GetSingleTickerProviderStateMixin {
  final home = NewHome.empty().obs;
  late TabController tabController;
  final selectedTab = 0.obs;

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
    NewHome data = await NewHomeViewApi.get();
    home.value = data;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}