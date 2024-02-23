// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonicity/src/models/album.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {/* Open Album */},
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
                imageUrl: album.image!.highQuality,
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
                    album.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    "${album.songCount!} Songs", maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
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

class AlbumCell extends StatelessWidget {
  final Album album;
  AlbumCell({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: album.image!.standardQuality,
              width: 140, height: 140, fit: BoxFit.fill,
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  width: 140, height: 140, fit: BoxFit.fill,
                );
              },
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  width: 140, height: 140, fit: BoxFit.fill,
                );
              },
            ),
          ),
          SizedBox(height: 2,),
          Text(
            album.name, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            "${album.language}",
            style: TextStyle(color: Colors.grey,  fontSize: 11),
          )
        ],
      ),
    );
  }
}

class AlbumRow extends StatelessWidget {
  final Album album;
  final String subtitle;
  AlbumRow({super.key,required this.album, required this.subtitle});

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
                imageUrl: album.image!.lowQuality,
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
                      album.name,
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

