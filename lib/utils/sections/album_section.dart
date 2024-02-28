import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';

class AlbumSection extends StatelessWidget {
  final Album album;
  const AlbumSection({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ToDoView(text: "Album Details"));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: album.image!.standardQuality, fit: BoxFit.cover, height: 150, width: 150,
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  fit: BoxFit.cover, height: 150, width: 150
                );
              },
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  fit: BoxFit.cover, height: 150, width: 150,
                );
              },
            ),
          ),
          Text(
            album.name,
            style: TextStyle(
              color: Colors.grey.shade50, fontSize: 21,
              decoration: TextDecoration.underline, decorationColor: Colors.grey.shade200
            )
          ),
        ],
      ),
    );
  }
}