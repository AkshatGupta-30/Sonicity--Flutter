// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/view_all_search_album_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';

class ViewAllAlbumsView extends StatelessWidget {
  ViewAllAlbumsView({super.key});

  final viewAllController = Get.find<ViewAllSearchAlbumsController>();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: media.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cover(media),
            _displayAlbums(media)
          ],
        ),
      ),
    );
  }

  Widget _cover(Size media) {
    return Obx(
      () {
        return SizedBox(
          height: media.width/1.2, width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              (viewAllController.albums.length < 4)
              ? CachedNetworkImage(
                imageUrl: viewAllController.albums.first.image.standardQuality,
                fit: BoxFit.cover, height: media.width/1.2, width: media.width/2,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/appLogo50x50.png",
                    fit: BoxFit.cover, height: media.width/1.2, width: media.width/2
                  );
                },
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/appLogo50x50.png",
                    fit: BoxFit.cover, height: media.width/1.2, width: media.width/2
                  );
                },
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: viewAllController.albums[index].image.standardQuality,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/images/appLogo50x50.png",
                        fit: BoxFit.cover, height: media.width/1.2, width: media.width/2
                      );
                    },
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/appLogo50x50.png",
                        fit: BoxFit.cover, height: media.width/1.2, width: media.width/2
                      );
                    },
                  );
                },
              ),
              Container(height: media.width/1.2, width: double.maxFinite, color: Colors.black.withOpacity(0.3)),
              Positioned(
                left: 10, top: 10,
                child: SafeArea(
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.75),
                    child: BackButton(color: Colors.white)
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Albums",
                          style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${viewAllController.albumCount.value} Albums",
                          style: TextStyle(color: Colors.grey.shade200, fontSize: 25),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 30, backgroundColor: Colors.black45,
                      child: IconButton(
                        onPressed: () {}, // TODO
                        icon: Icon(Icons.favorite_border, color: Colors.white, size: 40),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _displayAlbums(Size media) {
    return Obx(
      () {
        return SizedBox(
          height: media.height - media.width/1.2,
          child: ListView.builder(
            controller: viewAllController.scrollController,
            padding: EdgeInsets.all(15),
            itemCount: viewAllController.albums.length,
            itemBuilder: (context, index) {
              Album album = viewAllController.albums[index];
              return AlbumRow(album: album, subtitle: "${album.songCount!} Songs");
            },
          ),
        );
      }
    );
  }
}