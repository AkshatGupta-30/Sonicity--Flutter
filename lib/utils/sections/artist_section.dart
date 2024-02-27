import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';

class ArtistSection extends StatelessWidget {
  final List<Artist> artists;
  const ArtistSection({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ToDoView(text: "Artist Details"));
      },
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: artists.length,
          itemBuilder: (context, index) {
            Artist artist = artists[index];
            return Column(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: artist.image!.standardQuality, fit: BoxFit.cover, height: 150, width: 150,
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
                  artist.name,
                  style: TextStyle(
                    color: Colors.grey.shade50, fontSize: 21,
                    decoration: TextDecoration.underline, decorationColor: Colors.grey.shade200
                  )
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}