// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonicity/src/models/artist.dart';

class ArtistRow extends StatelessWidget {
  final Artist artist;
  final String subtitle;
  ArtistRow({super.key,required this.artist, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: artist.image.lowQuality,
                fit: BoxFit.cover, width: 60, height: 60,
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
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 26,
                    child: Text(
                      artist.name,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ),
                  SizedBox(
                    height: 20,
                    child: Text(
                      subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ),
                ],
              ),
            ),
            PopupMenuButton(
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
            )
          ]
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
