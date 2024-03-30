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

class RecentsView extends StatelessWidget {
  RecentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: RecentsController(),
              builder: (controller) {
                return CustomScrollView(
                  slivers: [
                    _appbar(context, controller),
                    _summaryHeader(context, controller),
                    _body(controller)
                  ],
                );
              }
            )
          ),
          MiniPlayerView()
        ],
      ),
    );
  }

  SliverAppBar _appbar(BuildContext context, RecentsController controller) {
    return SliverAppBar(
      pinned: true, shadowColor: Colors.transparent,
      title: Text("Recents"),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            if(controller.selectedTab.value == 0) {
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
            } else if(controller.selectedTab.value == 1) {
              return [
                PopupMenuItem(
                  onTap: () => controller.sortAlbums(SortType.name, Sort.asc),
                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortAlbums(SortType.name, Sort.dsc),
                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortAlbums(SortType.duration, Sort.asc),
                  child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Song Count Asc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortAlbums(SortType.duration, Sort.dsc),
                  child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Song Count Desc")
                ),
              ];
            } else if(controller.selectedTab.value == 2) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  onTap: () => controller.sortArtists(SortType.name, Sort.asc),
                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortArtists(SortType.name, Sort.dsc),
                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortArtists(SortType.duration, Sort.asc),
                  child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Type Asc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortArtists(SortType.duration, Sort.dsc),
                  child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Type Desc")
                ),
              ];
            } else {
              return [
                PopupMenuItem(
                  onTap: () => controller.sortPlaylists(SortType.name, Sort.asc),
                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortPlaylists(SortType.name, Sort.dsc),
                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortPlaylists(SortType.duration, Sort.asc),
                  child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Song Count Asc")
                ),
                PopupMenuItem(
                  onTap: () => controller.sortPlaylists(SortType.duration, Sort.dsc),
                  child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Song Count Desc")
                ),
              ];
            }
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
        tabs: [Tab(text: "Songs"), Tab(text: "Albums"), Tab(text: "Artists") , Tab(text: "Playlists")],
      ),
    );
  }

  SliverPinnedHeader _summaryHeader(BuildContext context, RecentsController controller) {
    return SliverPinnedHeader(
      child: Container(
        height: kBottomNavigationBarHeight,
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
        child: Obx(() => Row( 
          children: [
            Gap(20),
            Text(
              (controller.selectedTab.value == 0)
                  ? "${controller.songs.length} Songs"
                  : (controller.selectedTab.value == 1)
                      ? "${controller.albums.length} Albums"
                      : (controller.selectedTab.value == 2)
                          ? "${controller.artists.length} Artists"
                          : "${controller.playlists.length} Playlists",
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Spacer(),
            if(controller.selectedTab.value == 0)
              ShuffleNPlay(controller.songs, queueLabel: 'Recents',),
            Gap(8)
          ],
        )),
      ),
    );
  }

  SliverFillRemaining _body(RecentsController controller) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: controller.tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.songs.length,
            itemBuilder: (context, index) {
              Song song = controller.songs[controller.songs.length - index - 1];
              return SongTile(song);
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.albums.length,
            itemBuilder: (context, index) {
              Album album = controller.albums[controller.albums.length - index - 1];
              return AlbumTile(album, subtitle: "${album.songCount} Songs");
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.artists.length,
            itemBuilder: (context, index) {
              Artist artist = controller.artists[controller.artists.length - index - 1];
              return ArtistTile(artist, subtitle: "${artist.dominantType}");
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.playlists.length,
            itemBuilder: (context, index) {
              Playlist playlist = controller.playlists[controller.playlists.length - index - 1];
              return PlaylistTile(playlist, subtitle: "${playlist.songCount} Songs");
            },
          )),
        ],
      ),
    );
  }
}
