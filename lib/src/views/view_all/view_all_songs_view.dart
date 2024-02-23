// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/view_all_search_song_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class ViewAllSongsView extends StatelessWidget {
  ViewAllSongsView({super.key});

  final viewAllController = Get.find<ViewAllSearchSongsController>();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Container(
      height: media.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: CircleAvatar(
                  radius: 20, backgroundColor: Colors.black26,
                  child: BackButton(color: Colors.white)
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cover(media),
                      SizedBox(height: 10),
                      _displaySongs(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cover(Size media) {
    return Obx(
      () {
        return Container(
          margin: EdgeInsets.fromLTRB(10, 0 ,10, 10),
          height: media.width / 2.5, width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: media.width/2.5, width: media.width/2.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (viewAllController.songs.length < 4)
                    ? CachedNetworkImage(
                    imageUrl: viewAllController.songs.first.image.standardQuality,
                    fit: BoxFit.cover, height: media.width/2.5, width: media.width/2.5,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/images/appLogo50x50.png",
                        fit: BoxFit.cover, height: media.width/2.5, width: media.width/2.5,
                      );
                    },
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/appLogo50x50.png",
                        fit: BoxFit.cover, height: media.width/2.5, width: media.width/2.5,
                      );
                    },
                  )
                  : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      String image = viewAllController.songs[index].image.standardQuality;
                      return CachedNetworkImage(
                        imageUrl: image, fit: BoxFit.cover,
                        height: media.width/(2.6 * 2), width: media.width/(2.6 * 2),
                        errorWidget: (context, url, error) {
                          return Image.asset(
                            "assets/images/appLogo50x50.png",
                            fit: BoxFit.cover, height: media.width/(2.6 * 2), width: media.width/(2.6 * 2),
                          );
                        },
                        placeholder: (context, url) {
                          return Image.asset(
                            "assets/images/appLogo50x50.png",
                            fit: BoxFit.cover, height: media.width/(2.6 * 2), width: media.width/(2.6 * 2),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Songs",
                    style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${viewAllController.songs.length} Songs",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(// * : Play Button
                        onTap: (){},
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: EdgeInsets.only(left: 5, top: 10, right: 10, bottom: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.greenAccent, Colors.grey.shade200],
                              begin: Alignment.topCenter, end: Alignment.bottomCenter,
                              stops: [0.75, 1],
                            ),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, color: Colors.white, size: 30),
                              SizedBox(width: 3),
                              Text("Play", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)
                            ],
                          )
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: (){},
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                          child: Icon(Icons.shuffle, color: Colors.white, size: 30)
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )
        );
      }
    );
  }

  Widget _displaySongs() {
    return Obx(
      () {
        return Expanded(
          child: ListView.builder(
            controller: viewAllController.scrollController,
            itemCount: viewAllController.songs.length,
            itemBuilder: (context, index) {
              Song song = viewAllController.songs[index];
              return SongsRow(song: song);
            },
          ),
        );
      }
    );
  }
}