// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/searchview_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/view_all/view_all_albums_view.dart';
import 'package:sonicity/src/views/view_all/view_all_artist_view.dart';
import 'package:sonicity/src/views/view_all/view_all_playlist_view.dart';
import 'package:sonicity/src/views/view_all/view_all_songs_view.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/sections/search_shimmer.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/sections/view_all_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/artist_widget.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/widgets/search_history_cells.dart';
import 'package:sonicity/utils/widgets/search_widgte.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
      body: GetBuilder(
        init: SearchViewController(),
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
            child: SafeArea(
              child: Obx(() => Container(
                width: media.width, height: media.height,
                padding: EdgeInsets.all(15.0),
                child: CustomScrollView(
                  physics: (controller.searching.value)
                    ? AlwaysScrollableScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      leading: SizedBox(),
                      flexibleSpace: SizedBox(
                        height: 55,
                        child: SearchBox(
                          searchController: controller.searchController,
                          onChanged: (text) => controller.searchChanged(text),
                          onSubmitted: (text) => controller.searchSubmitted(text),
                        )
                      ),
                    ),
                    SliverToBoxAdapter(child: Gap(12)),
                    SliverToBoxAdapter(
                      child: (controller.loading.value)
                        ? SearchShimmer()
                        : (controller.searching.value)
                          ? _searchResults(controller)
                          : _searchHistory(controller),
                    )
                  ],
                ),
              )),
            ),
          );
        }
      ),
    );
  }

  Widget _searchHistory(SearchViewController controller) {
    return Obx(() => (controller.historyList.isEmpty)
      ? SizedBox()
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(// * : Heading
            padding: EdgeInsets.all(8.0),
            child: Text(
              "History",
              style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 25, ),
            ),
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
        ],
      )
    );
  }

  Widget _searchResults(SearchViewController controller) {
    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(controller.searchAll.value.topQuery.isNotEmpty())
          Column(// * : Top Results
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              TitleSection(title: "Top Results", leftPadding: 0, size: 22),
              Gap(10),
              if(controller.searchAll.value.topQuery.songs.isNotEmpty) // * : Top songs
                SizedBox(
                  height: 60.0 * controller.searchAll.value.topQuery.songs.length,
                  child: ListView.builder(
                    itemCount: controller.searchAll.value.topQuery.songs.length,
                    itemBuilder: (context, index) {
                      Song song = controller.searchAll.value.songs[index];
                      return SongsRow(song: song, subtitle: "Song");
                    },
                  ),
                )
              else if(controller.searchAll.value.topQuery.albums.isNotEmpty) // * : Top albums
                SizedBox(
                  height: 60.0 * controller.searchAll.value.topQuery.albums.length,
                  child: ListView.builder(
                    itemCount: controller.searchAll.value.topQuery.albums.length,
                    itemBuilder: (context, index) {
                      Album album = controller.searchAll.value.topQuery.albums[index];
                      return AlbumRow(album: album, subtitle: "Album");
                    },
                  ),
                )
              else if(controller.searchAll.value.topQuery.artists.isNotEmpty) // * : Top artists
                SizedBox(
                  height: 60.0 * controller.searchAll.value.topQuery.artists.length,
                  child: ListView.builder(
                    itemCount: controller.searchAll.value.topQuery.artists.length,
                    itemBuilder: (context, index) {
                      Artist artist = controller.searchAll.value.topQuery.artists[index];
                      return ArtistRow(artist: artist, subtitle: "Artist");
                    },
                  ),
                )
              else if(controller.searchAll.value.topQuery.playlists.isNotEmpty) // * : Top playlists
                SizedBox(
                  height: 60.0 * controller.searchAll.value.topQuery.playlists.length,
                  child: ListView.builder(
                    itemCount: controller.searchAll.value.topQuery.playlists.length,
                    itemBuilder: (context, index) {
                      Playlist playlist = controller.searchAll.value.topQuery.playlists[index];
                      return PlaylistRow(playlist: playlist, subtitle: "Playlist");
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
              Container(
                color: Colors.transparent,
                height: 70.0 * controller.searchAll.value.songs.length,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.searchAll.value.songs.length,
                  itemBuilder: (context, index) {
                    Song song = controller.searchAll.value.songs[index];
                    return SongsRow(song: song);
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
              Container(
                color: Colors.transparent,
                height: 70.0 * controller.searchAll.value.albums.length,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.searchAll.value.albums.length,
                  itemBuilder: (context, index) {
                    Album album = controller.searchAll.value.albums[index];
                    return AlbumRow(album: album, subtitle: album.language!);
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
              Container(
                color: Colors.transparent,
                height: 70.0 * controller.searchAll.value.artists.length,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.searchAll.value.artists.length,
                  itemBuilder: (context, index) {
                    Artist artist = controller.searchAll.value.artists[index];
                    return ArtistRow(artist: artist, subtitle: artist.description!);
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
                  Get.to(() => ViewAllPlaylistsView());
                },
              ),
              Container(
                color: Colors.transparent,
                height: 70.0 * controller.searchAll.value.playlists.length,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.searchAll.value.playlists.length,
                  itemBuilder: (context, index) {
                    Playlist playlist = controller.searchAll.value.playlists[index];
                    return PlaylistRow(playlist: playlist, subtitle: playlist.language!.capitalizeFirst!);
                  },
                ),
              ),
            ],
          ),
      ]
    ));
  }
}