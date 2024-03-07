import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/views/details/playlist_details_view.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';

class PlaylistCell extends StatelessWidget {
  final Playlist playlist;
  final String subtitle;
  PlaylistCell(this.playlist, {super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
        await recents.insertPlaylist(playlist);
        Get.to(
          () => PlaylistDetailsView(),
          arguments: playlist.id
        );
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
    return ListTile(
      onTap: () async {
        RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
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
      trailing: PlaylistPopUpMenu(playlist),
    );
  }
}

class PlaylistPopUpMenu extends StatelessWidget {
  final Playlist playlist;
  const PlaylistPopUpMenu(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Ic.round_cyclone, label: "Clone to Library"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Mi.favorite, label: "Add to Starred"),
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
