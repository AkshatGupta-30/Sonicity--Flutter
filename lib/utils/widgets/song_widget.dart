// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonicity/src/models/song.dart';

class SongCell extends StatelessWidget {
  final Song song;
  const SongCell({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {/* Play Button Pressed */},
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
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: popButtonRow(icon: Icons.add, label: "Add to Library"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: popButtonRow(icon: Icons.favorite_border, label: "Add to Favorities"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: popButtonRow(icon: Icons.queue_music, label: "Add to Queue"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: popButtonRow(icon: Icons.playlist_add, label: "Add to Playlist"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: popButtonRow(icon: Icons.album, label: "View Album"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: popButtonRow(icon: Icons.info_outline, label: "Song Info"),
                    )
                  ];
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.under,
                color: Colors.grey.shade900,
                icon: Icon(Icons.more_vert, color: Colors.grey.shade100, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row popButtonRow({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade100, size: 22),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade100, fontSize: 18),
        ),
      ],
    );
  }
}
