// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/homeview_controller.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/shimmer_widget.dart';

class HotPlaylistSection extends StatelessWidget {
  final Size media;
  HotPlaylistSection({super.key, required this.media});

  final hotPlaylists = Get.find<HomeViewController>().home.value.hotPlaylists;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSection(title: "Hot Playlist", size: 24),
        Gap(12),
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (hotPlaylists.playlists.isEmpty) ? 5 : hotPlaylists.playlists.length,
            itemBuilder: (context, index) {
              if(hotPlaylists.playlists.isEmpty) {
                return ShimmerCell();
              }
              Playlist playlist = hotPlaylists.playlists[index];
              return PlaylistCell(playlist, subtitle: '${playlist.songCount!} Songs');
            },
          ),
        )
      ],
    );
  }
}