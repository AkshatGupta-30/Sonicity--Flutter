// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/homeview_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';
import 'package:sonicity/utils/sections/view_all_section.dart';
import 'package:sonicity/utils/widgets/shimmer_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class LastSessionSection extends StatelessWidget {
  final Size media;
  final HomeViewController homeController;
  LastSessionSection({super.key, required this.media, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllSection(
          onPressed: () {
            Get.to(() => ToDoView(text: "View all last session song"));
          },
          title: "Last Session", buttonTitle: "View All",
          size: 24, rightPadding: 0,
        ),
        Obx(
          () {
            int listLength = (homeController.home.value.lastSession.length > 20) ? 20 : homeController.home.value.lastSession.length;
            if(homeController.home.value.lastSession.isEmpty) {
              return SizedBox(
                height: (homeController.home.value.lastSession.length > 4) ? 4 * 70 : homeController.home.value.lastSession.length * 70,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: (homeController.home.value.lastSession.length > 4) ? 4 : homeController.home.value.lastSession.length,
                  itemBuilder: (context, index) {
                    return ShimmerRow();
                  },
                ),
              );
            }
            return SizedBox(
              height: (listLength < 4) ? listLength * 72 : 4 * 72,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: (listLength <= 4) ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: (homeController.home.value.lastSession.length / 4).ceil(),
                itemBuilder: (context, outerIndex) {
                  var currentRowIndex = outerIndex * 4;
                  return SizedBox(
                    width: (homeController.home.value.lastSession.length <= 4) ? media.width / 1.05 : media.width / 1.2,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 4,
                      itemBuilder: (context, innerIndex) {
                        var currentItemIndex = currentRowIndex + innerIndex;
                        if (currentItemIndex < homeController.home.value.lastSession.length) {
                          Song song = homeController.home.value.lastSession[currentItemIndex];
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