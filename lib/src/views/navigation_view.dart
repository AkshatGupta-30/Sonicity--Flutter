// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icomoon_free.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/pajamas.dart';
import 'package:sonicity/src/controllers/navigation_controller.dart';
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
              Tabs(thisTab: 0, selectedTab: navController.selectedTab.value, icon: MaterialSymbols.queue_music_rounded, label: "Queue"),
              Tabs(thisTab: 1, selectedTab: navController.selectedTab.value, icon: Ion.home_outline, label: "Home"),
              Tabs(thisTab: 2, selectedTab: navController.selectedTab.value, icon: Ic.twotone_library_music, label: "Library"),
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
              leading: Iconify(Ion.home_outline, color: accentColor),
              title: Text("Home", style: TextStyle(color: accentColor)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Iconify(IconParkTwotone.folder_music, color: Colors.white,),
              title: Text("My Music", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Iconify(Pajamas.task_done, color: Colors.white,),
              title: Text("Added", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Iconify(Ic.sharp_playlist_play, color: Colors.white),
              title: Text("Playlists", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Iconify(Ion.settings_sharp, color: Colors.white),
              title: Text("Settings", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                navController.closeDrawer();
              },
              leading: Iconify(IcomoonFree.info, color: Colors.white),
              title: Text("About", style: TextStyle(color: Colors.white)),
            ),
            Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  WidgetSpan(child: Text("Made with ", style: GoogleFonts.arbutus(color: Colors.white))),
                  WidgetSpan(child: Iconify(MaterialSymbols.favorite_rounded, color: Colors.red)),
                  WidgetSpan(child: Text(" by Akshat Gupta", style: GoogleFonts.arbutus(color: Colors.white))),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}