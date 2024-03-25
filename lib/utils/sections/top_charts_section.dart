import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class TopChartsSection extends StatelessWidget {
  final Size media;
  TopChartsSection({super.key, required this.media});

  final topCharts = Get.find<HomeViewController>().topCharts.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSection(title: "Top Charts", size: 24),
        Gap(12),
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (topCharts.playlists.isEmpty) ? 5 : topCharts.playlists.length,
            itemBuilder: (context, index) {
              if(topCharts.playlists.isEmpty) {
                return ShimmerCell();
              }
              Playlist playlist = topCharts.playlists[index];
              return PlaylistCell(playlist, subtitle: playlist.language!);
            },
          ),
        )
      ],
    );
  }
}