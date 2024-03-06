import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter_plus/icons/codicon.dart';
import 'package:iconify_flutter_plus/icons/fa6_solid.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icomoon_free.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/src/controllers/navigation_controller.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/views/drawer/settings_view.dart';
import 'package:sonicity/src/views/navigation/library_view.dart';
import 'package:sonicity/src/views/navigation/homeview.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

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
      drawer: _drawer(context, controller),
      body: navTabs[controller.selectedIndex.value],
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        items: [
          BottomNavigationBarItem(
            icon: Iconify(
              MaterialSymbols.queue_music_rounded,
              color: (controller.selectedIndex.value == 0) ? Get.find<SettingsController>().getAccent : null
            ),
            label: "Queue"
          ),
          BottomNavigationBarItem(
            icon: Iconify(
              Fa6Solid.house_chimney,
              color: (controller.selectedIndex.value == 1)
                ? Get.find<SettingsController>().getAccent : null
            ),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Iconify(
              Ic.round_library_music,
              color: (controller.selectedIndex.value == 2)
                ? Get.find<SettingsController>().getAccent : null
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

  Drawer _drawer(BuildContext context, NavigationController controller) {
    return Drawer(
      child: BackgroundGradientDecorator(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              DrawerHeader(child: Center(child: Text("Sonicity", style: Theme.of(context).textTheme.displayLarge))),
              ListTile(
                onTap: () => controller.closeDrawer(),
                leading: Obx(() => Iconify(Ion.home_outline, color: Get.find<SettingsController>().getAccent)),
                title: Obx(() => Text("Home", style: TextStyle(color: Get.find<SettingsController>().getAccent))),
              ),
              ListTile(
                onTap: () => controller.closeDrawer(),
                leading: Iconify(IconParkTwotone.folder_music,),
                title: Text("My Music"),
              ),
              ListTile(
                onTap: () => controller.closeDrawer(),
                leading: Iconify(Codicon.repo_clone,),
                title: Text("Cloned"),
              ),
              ListTile(
                onTap: () => controller.closeDrawer(),
                leading: Iconify(Ic.sharp_playlist_play,),
                title: Text("Playlists"),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => SettingsView());
                  controller.closeDrawer();
                },
                leading: Iconify(Ion.settings_sharp,),
                title: Text("Settings"),
              ),
              ListTile(
                onTap: () => controller.closeDrawer(),
                leading: Iconify(IcomoonFree.info,),
                title: Text("About"),
              ),
              Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.arbutus(color: (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white),
                  children: [
                    TextSpan(text: "Made with "),
                    WidgetSpan(child: Iconify(MaterialSymbols.favorite_rounded, color: Colors.red)),
                    TextSpan(text: " by Akshat Gupta",),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}