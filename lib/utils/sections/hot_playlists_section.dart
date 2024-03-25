import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class HotPlaylistSection extends StatelessWidget {
  final Size media;
  HotPlaylistSection({super.key, required this.media});

  final hotPlaylists = Get.find<HomeViewController>().hotPlaylists.value;

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