// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter_plus/icons/entypo.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/sprefs/last_session_sprefs.dart';
import 'package:sonicity/src/views/details/album_details_view.dart';
import 'package:sonicity/src/views/details/song_details_view.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';

class SongCard extends StatelessWidget {
  final Song song;
  SongCard(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () async {
        LastSessionSprefs.add(song.id);
        RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
        int res = await recents.insert(song);
        "Insert : $res".printInfo();
      },
      child: Container(
        width: media.width/1.25, height: media.width/1.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: song.image.highQuality,
                width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/appLogo150x150.png",
                    width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/appLogo150x150.png",
                    width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                  );
                },
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: media.width/1.25, height: media.width/1.25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: (Theme.of(context).brightness == Brightness.light)
                      ? [Colors.white.withOpacity(0.25), Colors.grey.shade200]
                      : [Colors.black.withOpacity(0.25), Colors.black],
                    begin: Alignment.center, end: Alignment.bottomCenter,
                    stops: [0.4, 1]
                  )
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Text>[
                  Text(
                    song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  Text(
                    song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade800 : null
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0, right: 0,
              child: SongPopUpMenu(song),
            ),
          ],
        ),
      ),
    );
  }
}

class SongsTile extends StatelessWidget {
  final Song song;
  final String subtitle;
  SongsTile(this.song, {super.key, this.subtitle = ""});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: song.image.lowQuality, fit: BoxFit.cover, width: 50, height: 50,
          errorWidget: (context, url, error) {
            return Image.asset(
              "assets/images/appLogo50x50.png",
              fit: BoxFit.cover, width: 50, height: 50
            );
          },
          placeholder: (context, url) {
            return Image.asset(
              "assets/images/appLogo50x50.png",
              fit: BoxFit.cover, width: 50, height: 50
            );
          },
        ),
      ),
      horizontalTitleGap: 10,
      title: Text(
        song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        (subtitle.isEmpty) ? song.subtitle : subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      trailing:   SongPopUpMenu(song)
    );
  }
}

class SongPopUpMenu extends StatelessWidget {
  final Song song;
  SongPopUpMenu(this.song, {super.key});

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
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: MaterialSymbols.queue_music, label: "Add to Queue"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Tabler.playlist_add, label: "Add to Playlist"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            onTap: () {
              Get.to(
                () => AlbumDetailsView(),
                arguments: song.album!.id
              );
            },
            child: PopUpButtonRow(icon: MaterialSymbols.album, label: "View Album"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            onTap: () {
              Get.to(
                () => SongDetailsView(),
                arguments: song.id
              );
            },
            child: PopUpButtonRow(icon: Entypo.info_with_circle, label: "Song Info"),
          )
        ];
      },
      padding: EdgeInsets.zero,
      icon: Iconify(
        Ic.sharp_more_vert, size: 32,
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      ),
    );
  }
}