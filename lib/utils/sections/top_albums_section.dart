// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/services/home_view_api.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/shimmer_widget.dart';

class TopAlbumsSection extends StatelessWidget {
  final Size media;
  final HomeViewApi homeViewApi;
  TopAlbumsSection({super.key, required this.media, required this.homeViewApi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSection(title: "Top Albums", size: 24),
        SizedBox(height: 12),
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (homeViewApi.topAlbums.value.albums.isEmpty) ? 5 : homeViewApi.topAlbums.value.albums.length,
            itemBuilder: (context, index) {
              if(homeViewApi.topAlbums.value.albums.isEmpty) {
                return ShimmerCell(crossAxisAlignment: CrossAxisAlignment.start);
              }
              Album album = homeViewApi.topAlbums.value.albums[index];
              return AlbumCell(album: album);
            },
          ),
        )
      ],
    );
  }
}