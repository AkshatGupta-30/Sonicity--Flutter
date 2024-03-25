import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class MyPlaylistsSection extends StatelessWidget {
  final Size media;
  MyPlaylistsSection({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: MyPlaylistController(Song.empty()),
      builder: (controller) {
        if(controller.playlists.isEmpty) return SizedBox();
        return Obx(() => Column(
          children: [
            Gap(20),
            TitleSection(title: "My Playlists", size: 24),
            Gap(12),
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (controller.playlists.isEmpty) ? 5 : controller.playlists.length,
                itemBuilder: (context, index) {
                  MyPlaylist playlist = controller.playlists[index];
                  return MyPlaylistCell(playlist: playlist);
                },
              ),
            )
          ],
        ));
      }
    );
  }
}