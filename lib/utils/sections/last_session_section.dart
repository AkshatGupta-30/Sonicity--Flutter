// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/test_service.dart';
import 'package:sonicity/utils/sections/view_all_section.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class LastSessionSecton extends StatelessWidget {
  final Size media;
  final TestApi testApi;
  LastSessionSecton({super.key, required this.media, required this.testApi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllSection(
          onPressed: () {},
          title: "Last Session", buttonTitle: "View All",
          size: 24, rightPadding: 0,
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: (testApi.songsList.length / 4).ceil(),
            itemBuilder: (context, outerIndex) {
              var currentRowIndex = outerIndex * 4;
              return SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  addSemanticIndexes: true,
                  itemCount: 4,
                  itemBuilder: (context, innerIndex) {
                    var currentItemIndex = currentRowIndex + innerIndex;
                    if (currentItemIndex < testApi.songsList.length) {
                      Song song = Song.fromJson(testApi.songsList[currentItemIndex]);
                      return SongsRow(song: song);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}