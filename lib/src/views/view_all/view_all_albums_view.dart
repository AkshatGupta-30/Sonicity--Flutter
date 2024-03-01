// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/view_all_search_album_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';

class ViewAllAlbumsView extends StatelessWidget {
  ViewAllAlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
      body: GetBuilder(
        init: ViewAllSearchAlbumsController(Get.arguments),
        builder: (controller) {
          if(controller.albums.isEmpty) {
            return Center(
              child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
            );
          }
          return Container(
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
                _coverImage(media, controller),
                _displayAlbums(media, controller)
              ],
            ),
          );
        }
      ),
    );
  }

  Obx _displayAlbums(Size media, ViewAllSearchAlbumsController controller) {
    return Obx(() => SizedBox(
      height: media.height - media.width/1.2,
      child: ListView.builder(
        padding: EdgeInsets.all(15),
        controller: controller.scrollController,
        itemCount: (controller.isLoadingMore.value)
          ? controller.albums.length + 1
          : controller.albums.length,
        itemBuilder: (context, index) {
          if(index < controller.albums.length) {
            Album album = controller.albums[index];
            return AlbumRow(album: album, subtitle: "${album.songCount!} Songs");
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    ));
  }

  Obx _coverImage(Size media, ViewAllSearchAlbumsController controller) {
    return Obx(() => SizedBox(
      height: media.width/1.2, width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          (controller.albums.length < 4)
          ? CachedNetworkImage(
            imageUrl: controller.albums.first.image!.standardQuality,
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
                imageUrl: controller.albums[index].image!.standardQuality,
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
          Container(height: media.width/1.2, width: double.maxFinite, color: Colors.black.withOpacity(0.25)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Albums",
                  style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${controller.albumCount.value} Albums",
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 25),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}