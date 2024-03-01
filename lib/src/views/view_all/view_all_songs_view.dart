// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/view_all_search_song_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class ViewAllSongsView extends StatelessWidget {
  ViewAllSongsView({super.key});

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
          stops: [0.0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
        body: GetBuilder(
          init: ViewAllSearchSongsController(Get.arguments),
          builder: (controller) {
            if(controller.songs.isEmpty) {
              return Center(
                child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
              );
            }
            return SafeArea(
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
                          _cover(media, controller),
                          Gap(10),
                          _displaySongs(controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _cover(Size media, ViewAllSearchSongsController controller) {
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
              child: (controller.songs.length < 4)
                ? CachedNetworkImage(
                imageUrl: controller.songs.first.image.standardQuality,
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
                  String image = controller.songs[index].image.standardQuality;
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
                "${controller.songCount.value} Songs",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Gap(12),
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
                          Iconify(Ic.twotone_play_arrow, color: Colors.white, size: 30),
                          Gap(3),
                          Text("Play", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)
                        ],
                      )
                    ),
                  ),
                  Gap(10),
                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                      child: Iconify(Ph.shuffle_duotone, color: Colors.white, size: 30)
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

  Widget _displaySongs(ViewAllSearchSongsController controller) {
    return Obx(() => Expanded(
      child: ListView.builder(
        controller: controller.scrollController,
        itemCount: (controller.isLoadingMore.value)
          ? controller.songs.length + 1
          : controller.songs.length,
        itemBuilder: (context, index) {
          if(index < controller.songs.length) {
            Song song = controller.songs[index];
            return SongsRow(song: song);
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    ));
  }
}