// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/entypo.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:iconify_flutter_plus/icons/teenyicons.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/sprefs/last_session_sprefs.dart';

class SongCard extends StatelessWidget {
  final Song song;
  SongCard({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        /* Play Button Pressed */
        LastSessionSprefs.add(song.id);
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
                    colors: [Colors.black.withOpacity(0.25), Colors.black],
                    begin: Alignment.center, end: Alignment.bottomCenter,
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
                children: [
                  Text(
                    song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0, right: 0,
              child: SongPopUpMenu(),
            ),
          ],
        ),
      ),
    );
  }
}

class SongsRow extends StatelessWidget {
  final Song song;
  SongsRow({super.key,required this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.only(bottom: 10),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: song.image.lowQuality, fit: BoxFit.cover, width: 60, height: 60,
          errorWidget: (context, url, error) {
            return Image.asset(
              "assets/images/appLogo50x50.png",
              fit: BoxFit.cover, width: 60, height: 60
            );
          },
          placeholder: (context, url) {
            return Image.asset(
              "assets/images/appLogo50x50.png",
              fit: BoxFit.cover, width: 60, height: 60
            );
          },
        ),
      ),
      horizontalTitleGap: 10,
      title: Text(
        song.title,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      subtitle: Text(
        song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      trailing:   SongPopUpMenu()
    );
  }
}

class SongPopUpMenu extends StatelessWidget {
  const SongPopUpMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Teenyicons.section_add_solid, label: "Add to Library"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Mi.favorite, label: "Add to Favorities"),
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
            child: PopUpButtonRow(icon: MaterialSymbols.album, label: "View Album"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Entypo.info_with_circle, label: "Song Info"),
          )
        ];
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      color: Colors.grey.shade900,
      icon: Iconify(Ic.sharp_more_vert, color: Colors.grey.shade100, size: 32),
    );
  }
}

class PopUpButtonRow extends StatelessWidget {
  const PopUpButtonRow({
    super.key,
    required this.icon,
    required this.label,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Iconify(icon, color: Colors.grey.shade100, size: 22),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade100, fontSize: 18),
        ),
      ],
    );
  }
}
