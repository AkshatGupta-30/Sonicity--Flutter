import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final selectedTab = 1.obs;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
  void closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }
}