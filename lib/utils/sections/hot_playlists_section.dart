// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/homeview_controller.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/shimmer_widget.dart';

class HotPlaylistSection extends StatelessWidget {
  final Size media;
  final HomeViewController homeController;
  HotPlaylistSection({super.key, required this.media, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          children: [
            TitleSection(title: "Hot Playlist", size: 24),
            SizedBox(height: 12),
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (homeController.home.value.hotPlaylists.playlists.isEmpty) ? 5 : homeController.home.value.hotPlaylists.playlists.length,
                itemBuilder: (context, index) {
                  if(homeController.home.value.hotPlaylists.playlists.isEmpty) {
                    return ShimmerCell();
                  }
                  Playlist playlist = homeController.home.value.hotPlaylists.playlists[index];
                  return PlaylistCell(playlist: playlist);
                },
              ),
            )
          ],
        );
      }
    );
  }
}