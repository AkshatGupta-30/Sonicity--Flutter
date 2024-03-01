// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/top_albums.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/shimmer_widget.dart';

class TopAlbumsSection extends StatelessWidget {
  final Size media;
  final TopAlbums topAlbums;
  TopAlbumsSection({super.key, required this.media, required this.topAlbums});

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