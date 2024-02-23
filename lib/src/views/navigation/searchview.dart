// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/searchview_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/sections/search_shimmer.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/artist_widgte.dart';
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
    return ColoredBox(
      color: Colors.black,
      child: Container(
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
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: media.width, height: media.height,
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                physics: (searchViewCont.loading.value)
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 55,
                      child: SearchBox(
                        searchController: searchViewCont.searchController,
                        onChanged: (text) => searchViewCont.searchChanged(text),
                        onSubmitted: (text) => searchViewCont.searchSubmitted(text),
                      )
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () {
                        return (searchViewCont.loading.value)
                          ? SearchShimmer()
                          : (searchViewCont.searching.value)
                            ? _searchResults()
                            : _searchHistory();
                      }
                    )
                  ],
                ),
              ),
            ),
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
            Column(// * : Top Results
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TitleSection(title: "Top Results", leftPadding: 0, size: 22),
                SizedBox(height: 10),
                if(searchViewCont.searchAll.value.topQuery.songs.isNotEmpty) // * : Top songs
                  SizedBox(
                    height: 60.0 * searchViewCont.searchAll.value.songs.length,
                    child: ListView.builder(
                      itemCount: searchViewCont.searchAll.value.topQuery.songs.length,
                      itemBuilder: (context, index) {
                        Song song = searchViewCont.searchAll.value.songs[index];
                        return SongsRow(song: song);
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
                        return AlbumRow(album: album, subtitle: album.language!);
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
                        return ArtistRow(artist: artist, subtitle: artist.description!);
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
                        return PlaylistRow(playlist: playlist);
                      },
                    ),
                  )
              ],
            )
          ]
        );
      }
    );
  }
}