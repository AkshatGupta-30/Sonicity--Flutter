// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/services/test_service.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';
import 'package:sonicity/utils/widgets/title_section.dart';

class TopChartsSection extends StatelessWidget {
  final Size media;
  final TestApi testApi;
  TopChartsSection({super.key, required this.media, required this.testApi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSection(title: "Top Charts", size: 24),
        SizedBox(height: 12),
        SizedBox(
          height: media.width/1.5,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: testApi.playlistList.length,
            itemBuilder: (context, index) {
              Playlist playlist = Playlist.fromJson(testApi.playlistList[index]);
              return PlaylistCell(playlist: playlist);
            },
          ),
        )
      ],
    );
  }
}