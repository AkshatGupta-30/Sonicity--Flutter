import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class TopAlbumsSection extends StatelessWidget {
  final Size media;
  TopAlbumsSection({super.key, required this.media});

  final topAlbums = Get.find<HomeViewController>().topAlbums.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSection(title: "Top Albums", size: 24),
        Gap(12),
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (topAlbums.albums.isEmpty) ? 5 : topAlbums.albums.length,
            itemBuilder: (context, index) {
              if(topAlbums.albums.isEmpty) {
                return ShimmerCell(crossAxisAlignment: CrossAxisAlignment.start);
              }
              Album album = topAlbums.albums[index];
              return AlbumCell(album, subtitle: album.language!);
            },
          ),
        )
      ],
    );
  }
}