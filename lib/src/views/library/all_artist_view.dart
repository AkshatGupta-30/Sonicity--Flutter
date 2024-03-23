import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:sonicity/src/controllers/all_artists_controller.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/widgets/artist_widget.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class AllArtistsView extends StatelessWidget {
  AllArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AllArtistsController(),
      builder: (controller) {
        return Scaffold(
          body: BackgroundGradientDecorator(
            child: CustomScrollView(
              slivers: [
                _appbar(context, controller),
                _body(controller)
              ],
            ),
          ),
        );
      }
    );
  }

  SliverAppBar _appbar(BuildContext context, AllArtistsController controller) {
    return SliverAppBar(
      pinned: true, shadowColor: Colors.transparent,
      title: Text("All Artists"),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () => controller.sortArtist(SortType.name, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortArtist(SortType.name, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortArtist(SortType.duration, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Duration Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortArtist(SortType.duration, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Duration Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortArtist(SortType.year, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Year Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortArtist(SortType.year, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_descending, label: "Year Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded,),
          position: PopupMenuPosition.under,
          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ],
      bottom: TabBar(
        controller: controller.tabController,
        labelColor: (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Get.find<SettingsController>().getAccent, dividerColor: Get.find<SettingsController>().getAccentDark,
        tabs: [Tab(text: "Starred"), Tab(text: "Clones")],
      ),
    );
  }

  SliverFillRemaining _body(AllArtistsController controller) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: controller.tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.starArtists.length,
            itemBuilder: (context, index) {
              Artist artist = controller.starArtists[controller.starArtists.length - index - 1];
              return ArtistTile(artist, subtitle: artist.description!,);
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.cloneArtists.length,
            itemBuilder: (context, index) {
              Artist artist = controller.cloneArtists[controller.cloneArtists.length - index - 1];
              return ArtistTile(artist, subtitle: artist.description!,);
            },
          )),
        ],
      ),
    );
  }
}
