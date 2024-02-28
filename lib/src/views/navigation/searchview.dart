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
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/widgets/search_history_cells.dart';
import 'package:sonicity/utils/widgets/search_widgte.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final searchViewCont = Get.put(SearchViewController());

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
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
          child: Obx(
            () {
              return Container(
                width: media.width, height: media.height,
                padding: const EdgeInsets.all(15.0),
                child: CustomScrollView(
                  physics: (searchViewCont.searching.value)
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
                          searchController: searchViewCont.searchController,
                          onChanged: (text) => searchViewCont.searchChanged(text),
                          onSubmitted: (text) => searchViewCont.searchSubmitted(text),
                        )
                      ),
                    ),
                    SliverToBoxAdapter(child: Gap(12)),
                    SliverToBoxAdapter(
                      child: (searchViewCont.loading.value)
                        ? SearchShimmer()
                        : (searchViewCont.searching.value)
                          ? _searchResults()
                          : _searchHistory(),
                    )
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _searchHistory() {
    return Obx(
      () {
        if(searchViewCont.historyList.isEmpty) {
          return SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(// * : Heading
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "History",
                style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 25, ),
              ),
            ),
            Wrap(// * : All History Chip
              alignment: WrapAlignment.start,
              children: searchViewCont.historyList.asMap().entries.map((entry) {
                final int index = entry.key;
                final String itemText = entry.value;
                return SearchHistoryCell(
                  itemText: itemText,
                  onTap: () => searchViewCont.chipTapped(index),
                  onRemove: () => searchViewCont.chipRemoved(index),
                );
              }).toList(),
            ),
          ],
        );
      }
    );
  }

  Widget _searchResults() {
    return Obx(
      () {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(searchViewCont.searchAll.value.topQuery.isNotEmpty())
              Column(// * : Top Results
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20),
                  TitleSection(title: "Top Results", leftPadding: 0, size: 22),
                  Gap(10),
                  if(searchViewCont.searchAll.value.topQuery.songs.isNotEmpty) // * : Top songs
                    SizedBox(
                      height: 60.0 * searchViewCont.searchAll.value.topQuery.songs.length,
                      child: ListView.builder(
                        itemCount: searchViewCont.searchAll.value.topQuery.songs.length,
                        itemBuilder: (context, index) {
                          Song song = searchViewCont.searchAll.value.songs[index];
                          return SongsRow(song: song, subtitle: "Song");
                        },
                      ),
                    )
                  else if(searchViewCont.searchAll.value.topQuery.albums.isNotEmpty) // * : Top albums
                    SizedBox(
                      height: 60.0 * searchViewCont.searchAll.value.topQuery.albums.length,
                      child: ListView.builder(
                        itemCount: searchViewCont.searchAll.value.topQuery.albums.length,
                        itemBuilder: (context, index) {
                          Album album = searchViewCont.searchAll.value.topQuery.albums[index];
                          return AlbumRow(album: album, subtitle: "Album");
                        },
                      ),
                    )
                  else if(searchViewCont.searchAll.value.topQuery.artists.isNotEmpty) // * : Top artists
                    SizedBox(
                      height: 60.0 * searchViewCont.searchAll.value.topQuery.artists.length,
                      child: ListView.builder(
                        itemCount: searchViewCont.searchAll.value.topQuery.artists.length,
                        itemBuilder: (context, index) {
                          Artist artist = searchViewCont.searchAll.value.topQuery.artists[index];
                          return ArtistRow(artist: artist, subtitle: "Artist");
                        },
                      ),
                    )
                  else if(searchViewCont.searchAll.value.topQuery.playlists.isNotEmpty) // * : Top playlists
                    SizedBox(
                      height: 60.0 * searchViewCont.searchAll.value.topQuery.playlists.length,
                      child: ListView.builder(
                        itemCount: searchViewCont.searchAll.value.topQuery.playlists.length,
                        itemBuilder: (context, index) {
                          Playlist playlist = searchViewCont.searchAll.value.topQuery.playlists[index];
                          return PlaylistRow(playlist: playlist, subtitle: "Playlist");
                        },
                      ),
                    )
                ],
              ),
            if(searchViewCont.searchAll.value.songs.isNotEmpty) // * : Songs
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20),
                  ViewAllSection(
                    title: "Songs", buttonTitle: "View all", leftPadding: 0, rightPadding: 0, size: 22,
                    onPressed: () {
                      Get.to(() => ViewAllSongsView(searchText: searchViewCont.searchController.text));
                    },
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 70.0 * searchViewCont.searchAll.value.songs.length,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchViewCont.searchAll.value.songs.length,
                      itemBuilder: (context, index) {
                        Song song = searchViewCont.searchAll.value.songs[index];
                        return SongsRow(song: song);
                      },
                    ),
                  ),
                ],
              ),
            if(searchViewCont.searchAll.value.albums.isNotEmpty) // * : Albums
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20),
                  ViewAllSection(
                    title: "Albums", buttonTitle: "View all", leftPadding: 0, rightPadding: 0, size: 22,
                    onPressed: () {
                      Get.to(() => ViewAllAlbumsView());
                    },
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 70.0 * searchViewCont.searchAll.value.albums.length,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchViewCont.searchAll.value.albums.length,
                      itemBuilder: (context, index) {
                        Album album = searchViewCont.searchAll.value.albums[index];
                        return AlbumRow(album: album, subtitle: album.language!);
                      },
                    ),
                  ),
                ],
              ),
            if(searchViewCont.searchAll.value.artists.isNotEmpty) // * : Artists
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20),
                  ViewAllSection(
                    title: "Artists", buttonTitle: "View all", leftPadding: 0, rightPadding: 0, size: 22,
                    onPressed: () {
                      Get.to(() => ViewAllArtistsView());
                    },
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 70.0 * searchViewCont.searchAll.value.artists.length,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchViewCont.searchAll.value.artists.length,
                      itemBuilder: (context, index) {
                        Artist artist = searchViewCont.searchAll.value.artists[index];
                        return ArtistRow(artist: artist, subtitle: artist.description!);
                      },
                    ),
                  ),
                ],
              ),
            if(searchViewCont.searchAll.value.playlists.isNotEmpty) // * : Playlists
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
                    height: 70.0 * searchViewCont.searchAll.value.playlists.length,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchViewCont.searchAll.value.playlists.length,
                      itemBuilder: (context, index) {
                        Playlist playlist = searchViewCont.searchAll.value.playlists[index];
                        return PlaylistRow(playlist: playlist, subtitle: playlist.language!.capitalizeFirst!);
                      },
                    ),
                  ),
                ],
              ),
          ]
        );
      }
    );
  }
}