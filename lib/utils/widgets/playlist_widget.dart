import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/details/details_view.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class PlaylistCell extends StatelessWidget {
  final Playlist playlist;
  final String subtitle;
  PlaylistCell(this.playlist, {super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.to(() => PlaylistDetailsView(), arguments: playlist.id);
        RecentsDatabase recents = getIt<RecentsDatabase>();
        await recents.insertPlaylist(playlist);
      },
      child: Container(
        width: 140,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: playlist.image.medQuality,
                width: 140, height: 140, fit: BoxFit.fill,
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/playlistCover/playlistCover150x150.jpg",
                    width: 140, height: 140, fit: BoxFit.fill,
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/playlistCover/playlistCover150x150.jpg",
                    width: 140, height: 140, fit: BoxFit.fill,
                  );
                },
              ),
            ),
            Gap(2),
            Text(
              playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13),
            ),
            if(subtitle.isNotEmpty)
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 11),
              )
          ],
        ),
      ),
    );
  }
}

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final String subtitle;
  PlaylistTile(this.playlist, {super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: PlaylistController(playlist),
      builder: (controller) {
        return ListTile(
          onTap: () async {
            RecentsDatabase recents = getIt<RecentsDatabase>();
            await recents.insertPlaylist(playlist);
            Get.to(
              () => PlaylistDetailsView(),
              arguments: playlist.id
            );
          },
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: playlist.image.lowQuality,
              fit: BoxFit.cover, width: 50, height: 50,
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/playlistCover/playlistCover50x50.jpg",
                  fit: BoxFit.cover, width: 50, height: 50
                );
              },
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/playlistCover/playlistCover50x50.jpg",
                  fit: BoxFit.cover, width: 50, height: 50
                );
              },
            ),
          ),
          horizontalTitleGap: 10,
          title: Text(
            playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          trailing: PlaylistPopUpMenu(playlist, controller: controller,),
        );
      }
    );
  }
}

class PlaylistPopUpMenu extends StatelessWidget {
  final Playlist playlist;
  final PlaylistController controller;
  const PlaylistPopUpMenu(this.playlist, {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => controller.switchCloned(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(
              icon: (controller.isClone.value) ? Ic.twotone_cyclone : Ic.round_cyclone,
              label: (controller.isClone.value) ? "Remove from Library" : "Clone to Library"
            ),
          ),
          PopupMenuItem(
            onTap: () => controller.switchStarred(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(
              icon: (controller.isStar.value) ? Mi.favorite : Uis.favorite,
              label: (controller.isStar.value) ? "Remove from Star" : "Add to Starred"
            ),
          ),
        ];
      },
      padding: EdgeInsets.zero,
      icon: Iconify(
        Ic.sharp_more_vert,
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
        size: 32
      ),
    );
  }
}
