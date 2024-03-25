import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/controllers/starred_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/player/mini_player_view.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/artist_widget.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class StarredView extends StatelessWidget {
  StarredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: StarredController(),
              builder: (controller) => CustomScrollView(
                slivers: [_appbar(context, controller), _summaryHeader(context, controller), _body(controller)],
              ),
            ),
          ),
          MiniPlayerView()
        ],
      ),
    );
  }

  SliverAppBar _appbar(BuildContext context, StarredController controller) {
    return SliverAppBar(
      pinned: true, shadowColor: Colors.transparent,
      title: Text("Starred"),
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
        tabs: [Tab(text: "Songs"), Tab(text: "Albums"), Tab(text: "Artists"), Tab(text: "Playlists")],
      ),
    );
  }

  SliverPinnedHeader _summaryHeader(BuildContext context, StarredController controller) {
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
                          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,),
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
                        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            Gap(8)
          ],
        )),
      ),
    );
  }

  SliverFillRemaining _body(StarredController controller) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: controller.tabController,
        children: [
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.songs.length,
            itemBuilder: (context, index) {
              Song song = controller.songs[controller.songs.length - index - 1];
              return SongTile(song,);
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.albums.length,
            itemBuilder: (context, index) {
              Album album = controller.albums[controller.albums.length - index - 1];
              return AlbumTile(album, subtitle: '${album.songCount} Songs',);
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.artists.length,
            itemBuilder: (context, index) {
              Artist artist = controller.artists[controller.artists.length - index - 1];
              return ArtistTile(artist, subtitle: '${artist.dominantType}',);
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.playlists.length,
            itemBuilder: (context, index) {
              Playlist playlist = controller.playlists[controller.playlists.length - index - 1];
              return PlaylistTile(playlist, subtitle: '${playlist.songCount} Songs',);
            },
          )),
        ],
      ),
    );
  }
}