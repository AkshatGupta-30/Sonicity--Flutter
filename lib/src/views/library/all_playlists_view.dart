import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/all_playlists_controller.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:sonicity/src/views/todo/playlist_soongs.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class AllPlaylistsView extends StatelessWidget {
  AllPlaylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Playlists"),),
      body: BackgroundGradientDecorator(
        child: GetBuilder(
          init: AllPlaylistsController(),
          builder: (controller) {
            return Obx(() => ListView.builder(
              itemCount: controller.myPlaylists.length,
              itemBuilder: (context, index) {
                MyPlaylist playlist = controller.myPlaylists[index];
                return ListTile(
                  title: Text(playlist.name),
                  subtitle: Text("${playlist.songCount} Songs"),
                  onTap: () async {
                    final songs = await controller.db.getSongs(playlist.name);
                    Get.to(() => PlaylistSongs(songs: songs,));
                  },
                );
              },
            ));
          },
        ),
      ),
    );
  }
}