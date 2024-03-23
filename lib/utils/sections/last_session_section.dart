import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/controllers/recents_controller.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/library/recents_view.dart';
import 'package:sonicity/utils/sections/view_all_section.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class LastSessionSection extends StatelessWidget {
  final Size media;
  LastSessionSection({super.key, required this.media,});

  @override
  Widget build(BuildContext context) {
    if(!GetIt.I.isRegistered<RecentsDatabase>()) {
      return SizedBox();
    }
    final controller = Get.put(RecentsController());
    return Obx(
      () {
        if(controller.songs.isEmpty) return SizedBox();
        int listLength = (controller.songs.length > 20) ? 20 : controller.songs.length;
        return Column(
          children: [
            Gap(20),
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
                itemCount: (controller.songs.length / 4).ceil(),
                itemBuilder: (context, outerIndex) {
                  var currentRowIndex = outerIndex * 4;
                  return SizedBox(
                    width: (controller.songs.length <= 4) ? media.width / 1.05 : media.width / 1.2,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 4,
                      itemBuilder: (context, innerIndex) {
                        var currentItemIndex = currentRowIndex + innerIndex;
                        if (currentItemIndex < controller.songs.length) {
                          Song song = controller.songs[listLength - currentItemIndex - 1];
                          return SongTile(song);
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