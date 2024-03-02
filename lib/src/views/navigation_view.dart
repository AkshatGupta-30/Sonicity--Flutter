// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/codicon.dart';
import 'package:iconify_flutter_plus/icons/fa6_solid.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icomoon_free.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/src/controllers/navigation_controller.dart';
import 'package:sonicity/src/views/library/library_view.dart';
import 'package:sonicity/src/views/navigation/homeview.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';

class NavigationView extends StatelessWidget {
  NavigationView({super.key});

  final controller = Get.put(NavigationController());
  final navTabs = [
    Center(child: Text("Queue", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
    HomeView(),
    LibraryView()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.black,
      drawer: _drawer(controller),
      body: navTabs[controller.selectedIndex.value],
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        items: [
          BottomNavigationBarItem(
            icon: Iconify(
              MaterialSymbols.queue_music_rounded,
              color: (controller.selectedIndex.value == 0) ? accentColor : Colors.white
            ),
            label: "Queue"
          ),
          BottomNavigationBarItem(
            icon: Iconify(
              Fa6Solid.house_chimney,
              color: (controller.selectedIndex.value == 1) ? accentColor : Colors.white
            ),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Iconify(
              Ic.round_library_music,
              color: (controller.selectedIndex.value == 2) ? accentColor : Colors.white
            ),
            label: "Library"
          ),
        ],
        onTap: (index) {
          controller.selectedIndex.value = index;
        },
      ),
    ));
  }

  Drawer _drawer(NavigationController controller) {
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
                controller.closeDrawer();
              },
              leading: Iconify(Ion.home_outline, color: accentColor),
              title: Text("Home", style: TextStyle(color: accentColor)),
            ),
            ListTile(
              onTap: () {
                controller.closeDrawer();
              },
              leading: Iconify(IconParkTwotone.folder_music, color: Colors.white,),
              title: Text("My Music", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                controller.closeDrawer();
              },
              leading: Iconify(Codicon.repo_clone, color: Colors.white,),
              title: Text("Cloned", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                controller.closeDrawer();
              },
              leading: Iconify(Ic.sharp_playlist_play, color: Colors.white),
              title: Text("Playlists", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                controller.closeDrawer();
              },
              leading: Iconify(Ion.settings_sharp, color: Colors.white),
              title: Text("Settings", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                controller.closeDrawer();
              },
              leading: Iconify(IcomoonFree.info, color: Colors.white),
              title: Text("About", style: TextStyle(color: Colors.white)),
            ),
            Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <WidgetSpan>[
                  WidgetSpan(child: Text("Made with ", style: GoogleFonts.arbutus(color: Colors.white))),
                  WidgetSpan(child: Iconify(MaterialSymbols.favorite_rounded, color: Colors.red)),
                  WidgetSpan(child: Text(" by Akshat Gupta", style: GoogleFonts.arbutus(color: Colors.white))),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}