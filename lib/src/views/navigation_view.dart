// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/services/navigation_controller.dart';
import 'package:sonicity/src/views/navigation/homeview.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/bottom_nab_bar_tab.dart';
import 'package:sonicity/src/views/library/library_view.dart';

class NavigationView extends StatefulWidget {
  NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final navController = Get.put(NavigationController());

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this, initialIndex: navController.selectedTab.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: navController.scaffoldKey,
      drawer: _drawer(navController),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(child: Text("Queue", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
          HomeView(),
          LibraryView()
        ],
      ),
      bottomNavigationBar: Obx(
        () {
          return BottomAppBar(
            elevation: 1,
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: TabBar(
            controller: tabController,
            indicatorColor: Colors.transparent,
            dividerHeight: 0,
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            labelColor: accentColor,
            unselectedLabelColor: Colors.white,
            isScrollable: false,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            onTap: (value) => navController.selectedTab.value = value,
            tabs: [
              Tabs(thisTab: 0, selectedTab: navController.selectedTab.value, icon: Icons.queue_music_rounded, label: "Queue"),
              Tabs(thisTab: 1, selectedTab: navController.selectedTab.value, icon: Icons.home_rounded, label: "Home"),
              Tabs(thisTab: 2, selectedTab: navController.selectedTab.value, icon: Icons.library_music_rounded, label: "Library"),
            ],
          ),
              );
        }
      ),
    );
  }

  Drawer _drawer(NavigationController navController) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  "Sonicity",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Icon(Icons.home, color: accentColor),
              title: Text("Home", style: TextStyle(color: accentColor)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Icon(Icons.folder, color: Colors.white,),
              title: Text("My Music", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Icon(Icons.library_add_check, color: Colors.white,),
              title: Text("Added", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Icon(Icons.playlist_play, color: Colors.white),
              title: Text("Playlists", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text("Settings", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Icon(Icons.info_outline, color: Colors.white),
              title: Text("About", style: TextStyle(color: Colors.white)),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Made with ", style: TextStyle(color: Colors.white)),
                Icon(Icons.favorite, color: Colors.red),
                Text(" by Akshat Gupta", style: TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }
}