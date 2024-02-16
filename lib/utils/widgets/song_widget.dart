// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonicity/src/models/song.dart';

class SongTile extends StatelessWidget {
  final Song song;
  const SongTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: song.image.standardQuality,
              height: 180, fit: BoxFit.fill,
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  height: 180, fit: BoxFit.fill,
                );
              },
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  height: 180, fit: BoxFit.fill,
                );
              },
            ),
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    Text(
                      song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: PopButtonRow(icon: Icons.add, label: "Add to Library"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: PopButtonRow(icon: Icons.favorite_border, label: "Add to Favorities"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: PopButtonRow(icon: Icons.queue_music, label: "Add to Queue"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: PopButtonRow(icon: Icons.playlist_add, label: "Add to Playlist"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: PopButtonRow(icon: Icons.album, label: "View Album"),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: PopButtonRow(icon: Icons.info_outline, label: "Song Info"),
                    )
                  ];
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.under,
                color: Colors.grey.shade900,
                icon: Icon(Icons.more_vert, color: Colors.grey.shade100, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row PopButtonRow({required IconData icon, required String label}) {
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
