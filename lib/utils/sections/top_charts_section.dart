// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/homeview_controller.dart';
import 'package:sonicity/src/models/new_playlist.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/shimmer_widget.dart';

class TopChartsSection extends StatelessWidget {
  final Size media;
  final HomeViewController homeController;
  TopChartsSection({super.key, required this.media, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          children: [
            TitleSection(title: "Top Charts", size: 24),
            Gap(12),
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (homeController.home.value.topCharts.playlists.isEmpty) ? 5 : homeController.home.value.topCharts.playlists.length,
                itemBuilder: (context, index) {
                  if(homeController.home.value.topCharts.playlists.isEmpty) {
                    return ShimmerCell();
                  }
                  NewPlaylist playlist = homeController.home.value.topCharts.playlists[index];
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