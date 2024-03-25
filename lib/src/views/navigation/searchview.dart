
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/searchview_controller.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/player/mini_player_view.dart';
import 'package:sonicity/src/views/view_all/view_all_albums_view.dart';
import 'package:sonicity/src/views/view_all/view_all_artist_view.dart';
import 'package:sonicity/src/views/view_all/view_all_playlist_view.dart';
import 'package:sonicity/src/views/view_all/view_all_songs_view.dart';
import 'package:sonicity/utils/sections/search_shimmer.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/sections/view_all_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/artist_widget.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/widgets/search_history_cells.dart';
import 'package:sonicity/utils/widgets/search_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    var safeArea = MediaQuery.paddingOf(context);
    return Scaffold(
      body: BackgroundGradientDecorator(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GetBuilder(
              init: SearchViewController(),
              builder: (controller) {
                return CustomScrollView(
                  physics: (controller.isSearching.value)
                    ? AlwaysScrollableScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      pinned: true, toolbarHeight: kToolbarHeight + safeArea.top/2,
                      leadingWidth: 0, titleSpacing: 0,
                      title: SearchBox(
                        searchController: controller.searchController,
                        focusNode: controller.focusNode,
                        onChanged: (text) => controller.searchChanged(text),
                        onSubmitted: (text) => controller.searchSubmitted(text),
                      )
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                      sliver:  SliverToBoxAdapter(
                        child: (controller.isLoading.value)
                          ? SearchShimmer()
                          : (controller.isSearching.value)
                            ? _searchResults(controller)
                            : _searchHistory(context, controller),
                      ),
                    )
                  ],
                );
              }
            ),
            MiniPlayerView()
          ],
        ),
      ),
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
    );
  }

  Widget _searchHistory(BuildContext context, SearchViewController controller) {
    return (controller.historyList.isEmpty)
      ? SizedBox()
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Obx(() => Text(
              "History",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Get.find<SettingsController>().getAccent),
            )),
          ),
          Wrap(// * : All History Chip
            alignment: WrapAlignment.start,
            children: controller.historyList.asMap().entries.map((entry) {
              final int index = entry.key;
              final String itemText = entry.value;
              return SearchHistoryCell(
                itemText: itemText,
                onTap: () => controller.chipTapped(index),
                onRemove: () => controller.chipRemoved(index),
              );
            }).toList(),
          ),
        ]
      );
  }

  Obx _searchResults(SearchViewController controller) {
    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Column>[
        if(controller.searchAll.value.topQuery.isNotEmpty())
          Column(// * : Top Results
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleSection(title: "Top Results", leftPadding: 0, size: 22),
              if(controller.searchAll.value.topQuery.songs.isNotEmpty) // * : Top songs
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                    itemCount: controller.searchAll.value.topQuery.songs.length,
                    itemBuilder: (context, index) {
                      Song song = controller.searchAll.value.songs[index];
                      return SongCell(song, subtitle: 'Song',);
                    },
                  ),
                )
              else if(controller.searchAll.value.topQuery.albums.isNotEmpty) // * : Top albums
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                    itemCount: controller.searchAll.value.topQuery.albums.length,
                    itemBuilder: (context, index) {
                      Album album = controller.searchAll.value.topQuery.albums[index];
                      return AlbumCell(album, subtitle: "Album", alignment: CrossAxisAlignment.center,);
                    },
                  ),
                )
              else if(controller.searchAll.value.topQuery.artists.isNotEmpty) // * : Top artists
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                    itemCount: controller.searchAll.value.topQuery.artists.length,
                    itemBuilder: (context, index) {
                      Artist artist = controller.searchAll.value.topQuery.artists[index];
                      return ArtistCell(artist, subtitle: "Artist");
                    },
                  ),
                )
              else if(controller.searchAll.value.topQuery.playlists.isNotEmpty) // * : Top playlists
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                    itemCount: controller.searchAll.value.topQuery.playlists.length,
                    itemBuilder: (context, index) {
                      Playlist playlist = controller.searchAll.value.topQuery.playlists[index];
                      return PlaylistCell(playlist, subtitle: "Playlist");
                    },
                  ),
                )
            ],
          ),
        if(controller.searchAll.value.songs.isNotEmpty) // * : Songs
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              ViewAllSection(
                title: "Songs", buttonTitle: "View all", leftPadding: 0, rightPadding: 0, size: 22,
                onPressed: () {
                  Get.to(
                    () => ViewAllSongsView(),
                    arguments: controller.searchController.text
                  );
                },
              ),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                  itemCount: controller.searchAll.value.songs.length,
                  itemBuilder: (context, index) {
                    Song song = controller.searchAll.value.songs[index];
                    return SongCell(song);
                  },
                ),
              ),
            ],
          ),
        if(controller.searchAll.value.albums.isNotEmpty) // * : Albums
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              ViewAllSection(
                title: "Albums", buttonTitle: "View all", leftPadding: 0, rightPadding: 0, size: 22,
                onPressed: () {
                  Get.to(
                    () => ViewAllAlbumsView(),
                    arguments: controller.searchController.text
                  );
                },
              ),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                  itemCount: controller.searchAll.value.albums.length,
                  itemBuilder: (context, index) {
                    Album album = controller.searchAll.value.albums[index];
                    return AlbumCell(album, subtitle: album.language!, alignment: CrossAxisAlignment.center,);
                  },
                ),
              ),
            ],
          ),
        if(controller.searchAll.value.artists.isNotEmpty) // * : Artists
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              ViewAllSection(
                title: "Artists", buttonTitle: "View all", leftPadding: 0, rightPadding: 0, size: 22,
                onPressed: () {
                  Get.to(
                    () => ViewAllArtistsView(),
                    arguments: controller.searchController.text
                  );
                },
              ),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                  itemCount: controller.searchAll.value.artists.length,
                  itemBuilder: (context, index) {
                    Artist artist = controller.searchAll.value.artists[index];
                    return ArtistCell(artist, subtitle: artist.description!);
                  },
                ),
              ),
            ],
          ),
        if(controller.searchAll.value.playlists.isNotEmpty) // * : Playlists
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              ViewAllSection(
                title: "Playlists", buttonTitle: "View all", leftPadding: 0, rightPadding: 0, size: 22,
                onPressed: () {
                  Get.to(
                    () => ViewAllPlaylistsView(),
                    arguments: controller.searchController.text
                  );
                },
              ),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10), scrollDirection: Axis.horizontal,
                  itemCount: controller.searchAll.value.playlists.length,
                  itemBuilder: (context, index) {
                    Playlist playlist = controller.searchAll.value.playlists[index];
                    return PlaylistCell(playlist, subtitle: playlist.language!.capitalizeFirst!);
                  },
                ),
              ),
            ],
          ),
      ]
    ));
  }
}