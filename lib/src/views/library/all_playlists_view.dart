import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
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
    return GetBuilder(
      init: MyPlaylistController(Song.empty()),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text("Playlists"),),
          body: BackgroundGradientDecorator(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Obx(() => CustomScrollView(
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
                  SliverToBoxAdapter(
                    child: SwitchListTile(
                      value: controller.isMerge.value,
                      onChanged: (value) => controller.isMerge.value = value,
                      secondary: Iconify(MaterialSymbols.merge_type_rounded, size: 30,),
                      title: Text("Merge Playlist", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
                      activeTrackColor: controller.settings.getAccentDark,
                      activeColor: controller.settings.getAccent,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.grey.shade300,
                    ),
                  ),
                  SliverToBoxAdapter(child: Gap(10)),
                  SliverList.builder(
                    itemCount: controller.playlists.length,
                    itemBuilder: (context, index) {
                      return (controller.isMerge.value)
                        ? MyPlaylistMergeTile(controller: controller, index: index)
                        : MyPlaylistViewTile(controller: controller, index: index,);
                    },
                  ),
                ],
              )),
            ),
          ),
          floatingActionButton: 
          Obx(() {
            bool shouldShowButton = controller.isMerging.where((element) => element).length > 1 && controller.isMerge.value;
            if(shouldShowButton) return FloatingActionButton.extended(
              onPressed: () => controller.mergePlaylist(),
              label: Text("Merge", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
              backgroundColor: controller.settings.getAccent,
              elevation: 2,
            );
            else return SizedBox();
          }),
        );
      }
    );
  }
}