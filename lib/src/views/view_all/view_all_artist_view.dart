// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/view_all_search_artist_controller.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/utils/widgets/artist_widget.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';

class ViewAllArtistsView extends StatelessWidget {
  ViewAllArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
      body: GetBuilder(
        init: ViewAllSearchArtistsController(Get.arguments),
        builder: (controller) {
          if(controller.artists.isEmpty) {
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
                _cover(media, controller),
                _displayArtists(media, controller)
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _cover(Size media, ViewAllSearchArtistsController controller) {
    double imageSize = 100;
    return Obx(() => SizedBox(
      height: media.width / 1.2, width: media.width,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SizedBox(
            height: media.width/1.2, width: double.maxFinite,
            child: (controller.artists.length < 6)
            ? CachedNetworkImage(
              imageUrl: controller.artists.first.image!.highQuality, fit: BoxFit.cover,
              height: media.width/1.15, width: media.width/2,
              errorWidget: (context, url, error) {
                return Image.network("https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg", fit: BoxFit.cover, height: media.width/1.15, width: media.width/2,);
              },
              placeholder: (context, url) {
                return Image.network("https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg", fit: BoxFit.cover, height: media.width/1.15, width: media.width/2,);
              },
            )
            : SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: media.width/10, left: 20,
                    child: CoverImages(image: controller.artists[0].image!.standardQuality, size: imageSize)
                  ),
                  Positioned(
                    top: 10, left: media.width/2 - imageSize/2,
                    child: CoverImages(image: controller.artists[1].image!.standardQuality, size: imageSize)
                  ),
                  Positioned(
                    top: media.width/10, right: 20,
                    child: CoverImages(image: controller.artists[2].image!.standardQuality, size: imageSize)
                  ),
                  Positioned(
                    bottom: media.width/10, left: 20,
                    child: CoverImages(image: controller.artists[3].image!.standardQuality, size: imageSize)
                  ),
                  Positioned(
                    bottom: 10, left: media.width/2 - imageSize/2,
                    child: CoverImages(image: controller.artists[4].image!.standardQuality, size: imageSize)
                  ),
                  Positioned(
                    bottom: media.width/10, right: 20,
                    child: CoverImages(image: controller.artists[5].image!.standardQuality, size: imageSize)
                  ),
                ],
              ),
            ),
          ),
          Container(height: media.width/1.15, width: double.maxFinite, color: Colors.black.withOpacity(0.25)),
          Positioned(
            left: 10, top: 10,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  shape: BoxShape.circle
                ),
                child: BackButton(color: Colors.white)
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15), alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Artists",
                  style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${controller.artistCount.value} Artists",
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 25),
                ),
              ],
            ),
          )
        ],
      )
    ));
  }

  Widget _displayArtists(Size media, ViewAllSearchArtistsController controller) {
    return Obx(() => SizedBox(
      height: media.height - media.width/1.2,
      child: ListView.builder(
        padding: EdgeInsets.all(15),
        controller: controller.scrollController,
        itemCount: (controller.isLoadingMore.value)
          ? controller.artists.length + 1
          : controller.artists.length,
        itemBuilder: (context, index) {
          if(index < controller.artists.length) {
            Artist artist = controller.artists[index];
            return ArtistRow(artist: artist, subtitle: artist.description!);
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    ));
  }
}

class CoverImages extends StatelessWidget {
  final String image;
  final double size;
  CoverImages({super.key, required this.image, required this.size});


  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: image, fit: BoxFit.cover,
        height: size, width: size,
        errorWidget: (context, url, error) {
          return Image.asset(
            "assets/images/appLogo50x50.png",
            fit: BoxFit.cover, height: size, width: size
          );
        },
        placeholder: (context, url) {
          return Image.asset(
            "assets/images/appLogo50x50.png",
            fit: BoxFit.cover, height: size, width: size
          );
        },
      ),
    );
  }
}