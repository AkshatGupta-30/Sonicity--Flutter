import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/views/drawer/drawer_view.dart';
import 'package:sonicity/src/views/library/all_playlists_view.dart';
import 'package:sonicity/src/views/navigation/navigation.dart';
import 'package:sonicity/src/views/navigation/queueview.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class NavigationView extends StatelessWidget {
  NavigationView({super.key});

  final controller = Get.put(NavigationController());
  final navTabs = [QueueView(), HomeView(), LibraryView()];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      key: controller.scaffoldKey,
      drawer: _drawer(context, controller),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TabBarView(
            controller: controller.tabController,
            physics: NeverScrollableScrollPhysics(),
            children: navTabs,
          ),
          MiniPlayerView()
        ],
      ),
      bottomNavigationBar: Container(
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
        child: TabBar(
          controller: controller.tabController,
          unselectedLabelColor: (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white,
          tabs: [
            Tab(
              icon: Iconify(
                MaterialSymbols.queue_music_rounded,
                color: (controller.selectedTab.value == 0) ? Get.find<SettingsController>().getAccent : null
              ),
              text: "Queue"
            ),
            Tab(
              icon: Iconify(
                Fa6Solid.house_chimney,
                color: (controller.selectedTab.value == 1)
                  ? Get.find<SettingsController>().getAccent : null
              ),
              text: "Home"
            ),
            Tab(
              icon: Iconify(
                Ic.round_library_music,
                color: (controller.selectedTab.value == 2)
                  ? Get.find<SettingsController>().getAccent : null
              ),
              text: "Library"
            ),
          ],
          onTap: (index) {
            controller.selectedTab.value = index;
          },
        ),
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
                onTap: () {
                  controller.closeDrawer();
                  if(controller.tabController.index != 1) controller.tabController.animateTo(1);
                },
                leading: Iconify(Ion.home_outline, color: (controller.tabController.index == 1) ? Get.find<SettingsController>().getAccent : null),
                title: Text("Home", style: TextStyle(color: (controller.tabController.index == 1) ? Get.find<SettingsController>().getAccent : null)),
              ),
              ListTile(
                onTap: () {
                  controller.closeDrawer();
                  if(controller.tabController.index != 2) controller.tabController.animateTo(2);
                },
                leading: Iconify(IconParkTwotone.folder_music, color: (controller.tabController.index == 2) ? Get.find<SettingsController>().getAccent : null),
                title: Text("Library", style: TextStyle(color: (controller.tabController.index == 2) ? Get.find<SettingsController>().getAccent : null),),
              ),
              ListTile(
                onTap: () {
                  controller.closeDrawer();
                  Get.to(() => AllPlaylistsView());
                },
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