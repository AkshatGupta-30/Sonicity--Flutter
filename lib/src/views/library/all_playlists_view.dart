import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:sonicity/src/controllers/my_playlist_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/my_playlist_widget.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class AllPlaylistsView extends StatelessWidget {
  AllPlaylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Playlists"),),
      body: BackgroundGradientDecorator(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: GetBuilder(
            init: MyPlaylistController(Song.empty()),
            builder: (controller) {
              return Obx(() => CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: ListTile(
                      onTap: () => showDialog(
                        context: context, barrierDismissible: true, useRootNavigator: true,
                        builder: (ctx) => NewPlaylistDialog(controller),
                      ),
                      leading: Iconify(Tabler.playlist_add, size: 30,),
                      title: Text("Create Playlist", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),)
                    ),
                  ),
                  SliverToBoxAdapter(child: Gap(10)),
                  SliverList.builder(
                    itemCount: controller.playlists.length,
                    itemBuilder: (context, index) => MyPlaylistViewTile(controller: controller, index: index,),
                  ),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }
}