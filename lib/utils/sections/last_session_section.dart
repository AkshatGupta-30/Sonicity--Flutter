// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/recents_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/library/recents_view.dart';
import 'package:sonicity/utils/sections/view_all_section.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class LastSessionSection extends StatelessWidget {
  final Size media;
  LastSessionSection({super.key, required this.media,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecentsController>();
    return Obx(
      () {
        if(controller.recentSongs.isEmpty) return SizedBox();
        int listLength = (controller.recentSongs.length > 20) ? 20 : controller.recentSongs.length;
        return Column(
          children: [
            ViewAllSection(
              onPressed: () => Get.to(() => RecentsView()),
              title: "Last Session", buttonTitle: "View All",
              size: 24, rightPadding: 0,
            ),
            SizedBox(
              height: (listLength < 4) ? listLength * 72 : 4 * 72,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: (listLength <= 4) ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: (controller.recentSongs.length / 4).ceil(),
                itemBuilder: (context, outerIndex) {
                  var currentRowIndex = outerIndex * 4;
                  return SizedBox(
                    width: (controller.recentSongs.length <= 4) ? media.width / 1.05 : media.width / 1.2,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 4,
                      itemBuilder: (context, innerIndex) {
                        var currentItemIndex = currentRowIndex + innerIndex;
                        if (currentItemIndex < controller.recentSongs.length) {
                          Song song = controller.recentSongs[listLength - currentItemIndex - 1];
                          return SongsTile(song);
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    );
  }
}