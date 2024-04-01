import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class AllSongsView extends StatelessWidget {
  AllSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: AllSongsController(),
              builder: (controller) {
                return CustomScrollView(
                  slivers: [
                    _appbar(context, controller),
                    _summaryHeader(context, controller),
                    _body(controller)
                  ],
                );
              }
            ),
          ),
          MiniPlayerView()
        ],
      ),
    );
  }

  SliverAppBar _appbar(BuildContext context, AllSongsController controller) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true, shadowColor: Colors.transparent,
      title: Text("All Songs"),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () => controller.sortSongs(SortType.name, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortSongs(SortType.name, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortSongs(SortType.duration, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Duration Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortSongs(SortType.duration, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Duration Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortSongs(SortType.year, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Year Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortSongs(SortType.year, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_descending, label: "Year Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded,),
          position: PopupMenuPosition.under,
          color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ],
      bottom: TabBar(
        controller: controller.tabController,
        labelColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Get.find<SettingsController>().getAccent, dividerColor: Get.find<SettingsController>().getAccentDark,
        tabs: [Tab(text: "Starred"), Tab(text: "Clones")],
      ),
    );
  }

  SliverPinnedHeader _summaryHeader(BuildContext context, AllSongsController controller) {
    final theme = Theme.of(context);
    return SliverPinnedHeader(
      child: Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: (theme.brightness == Brightness.light) ? Colors.grey.shade200 : Colors.grey.shade800,
          boxShadow: [BoxShadow(
            color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
            spreadRadius: 1, blurRadius: 5
          )]
        ),
        child: Row(
          children: [
            Gap(20),
            Obx(() => (controller.selectedTab.value == 0)
                ? Text("${controller.starSongs.length} Songs", style: theme.textTheme.bodyLarge)
                : Text("${controller.cloneSongs.length} Songs", style: theme.textTheme.bodyLarge)),
            Spacer(),
            Container(
              height: kBottomNavigationBarHeight, alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Shuffle",
                        style: TextStyle(color: Colors.grey.shade300, fontSize: 21),
                      ),
                      Iconify(
                        Ic.twotone_shuffle, size: 25,
                        color: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,),
                    ],
                  ),
                  Gap(5),
                  Container(height: 30, width: 1, color: Colors.white38),
                  Gap(5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Iconify(
                      Ic.twotone_play_arrow, size: 27,
                      color: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8)
          ],
        ),
      )
    );
  }

  SliverFillRemaining _body(AllSongsController controller) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: controller.tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.starSongs.length,
            itemBuilder: (context, index) {
              Song song = controller.starSongs[controller.starSongs.length - index - 1];
              return SongTile(song);
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.cloneSongs.length,
            itemBuilder: (context, index) {
              Song song = controller.cloneSongs[controller.cloneSongs.length - index - 1];
              return SongTile(song);
            },
          )),
        ],
      ),
    );
  }
}