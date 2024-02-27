// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/view_all_search_playlist_controller.dart';
import 'package:sonicity/src/models/new_playlist.dart';
import 'package:sonicity/utils/widgets/playlist_widget.dart';

class ViewAllPlaylistsView extends StatelessWidget {
  ViewAllPlaylistsView({super.key});

  final viewAllController = Get.find<ViewAllSearchPlaylistsController>();

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
            _displayPlaylists(media)
          ],
        ),
      ),
    );
  }

  Widget _cover(Size media) {
    double imageSize = 125;
    return Obx(
      () {
        return SizedBox(
          height: media.width / 1.2, width: media.width,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              SizedBox(
                height: media.width/1.2, width: double.maxFinite,
                child: (viewAllController.playlists.length < 6)
                ? CachedNetworkImage(
                  imageUrl: viewAllController.playlists.first.image.highQuality, fit: BoxFit.cover,
                  height: media.width/1.15, width: media.width/2,
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      "assets/images/appLogo50x50.png",
                      fit: BoxFit.cover, height: media.width/1.15, width: media.width/2
                    );
                  },
                  placeholder: (context, url) {
                    return Image.asset(
                      "assets/images/appLogo50x50.png",
                      fit: BoxFit.cover, height: media.width/1.15, width: media.width/2
                    );
                  },
                )
                : SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10, right: 30,
                        child: CoverImages(image: viewAllController.playlists[1].image.standardQuality, size: imageSize)
                      ),
                      Positioned(
                        right: 30, bottom: 10,
                        child: CoverImages(image: viewAllController.playlists[2].image.standardQuality, size: imageSize)
                      ),
                      Positioned(
                        bottom: 10, left: 30,
                        child: CoverImages(image: viewAllController.playlists[3].image.standardQuality, size: imageSize)
                      ),
                      Positioned(
                        top: 10, left: 30,
                        child: CoverImages(image: viewAllController.playlists[4].image.standardQuality, size: imageSize)
                      ),
                      Center(child: CoverImages(image: viewAllController.playlists.first.image.standardQuality, size: imageSize)
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
                      "Playlists",
                      style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${viewAllController.playlistCount.value} Playlists",
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 25),
                    ),
                  ],
                ),
              )
            ],
          )
        );
      }
    );
  }

  Widget _displayPlaylists(Size media) {
    return Obx(
      () {
        return SizedBox(
          height: media.height - media.width/1.2,
          child: ListView.builder(
            padding: EdgeInsets.all(15),
            controller: viewAllController.scrollController,
            itemCount: (viewAllController.isLoadingMore.value)
              ? viewAllController.playlists.length + 1
              : viewAllController.playlists.length,
            itemBuilder: (context, index) {
              if(index < viewAllController.playlists.length) {
                NewPlaylist playlist = viewAllController.playlists[index];
                return PlaylistRow(playlist: playlist, subtitle: "${playlist.songCount} Songs");
              } else {
                return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
              }
            },
          ),
        );
      }
    );
  }
}

class CoverImages extends StatelessWidget {
  final String image;
  final double size;
  const CoverImages({super.key, required this.image, required this.size});


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