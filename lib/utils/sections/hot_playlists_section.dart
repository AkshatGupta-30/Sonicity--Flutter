// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/services/home_view_api.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/sections/title_section.dart';

class HotPlaylistSection extends StatelessWidget {
  final Size media;
  final HomeViewApi homeViewApi;
  HotPlaylistSection({super.key, required this.media, required this.homeViewApi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSection(title: "Hot Playlist", size: 24),
        SizedBox(height: 12),
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeViewApi.hotPlaylist.value.playlists.length,
            itemBuilder: (context, index) {
              Playlist playlist = homeViewApi.hotPlaylist.value.playlists[index];
              return PlaylistCell(playlist: playlist);
            },
          ),
        )
      ],
    );
  }
}