// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/home_view_api.dart';
import 'package:sonicity/utils/sections/view_all_section.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class LastSessionSection extends StatelessWidget {
  final Size media;
  final HomeViewApi homeViewApi;
  LastSessionSection({super.key, required this.media, required this.homeViewApi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllSection(
          onPressed: () {},// TODO
          title: "Last Session", buttonTitle: "View All",
          size: 24, rightPadding: 0,
        ),
        Obx(
          () {
            int listLength = (homeViewApi.lastSessionSongs.length > 20) ? 20 : homeViewApi.lastSessionSongs.length;
            return SizedBox(
              height: (listLength < 4) ? listLength * 70 : 4 * 70,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: (listLength <= 4) ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: (homeViewApi.lastSessionSongs.length / 4).ceil(),
                itemBuilder: (context, outerIndex) {
                  var currentRowIndex = outerIndex * 4;
                  return SizedBox(
                    width: (homeViewApi.lastSessionSongs.length <= 4) ? media.width / 1.05 : media.width / 1.2,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      addSemanticIndexes: true,
                      itemCount: 4,
                      itemBuilder: (context, innerIndex) {
                        var currentItemIndex = currentRowIndex + innerIndex;
                        if (currentItemIndex < homeViewApi.lastSessionSongs.length) {
                          Song song = homeViewApi.lastSessionSongs[currentItemIndex];
                          return SongsRow(song: song);
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }
        )
      ],
    );
  }
}