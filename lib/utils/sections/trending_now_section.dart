// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:sonicity/src/controllers/homeview_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/shimmer_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/sections/title_section.dart';

class TrendingNowSection extends StatelessWidget {
  final Size media;
  final HomeViewController homeController;
  TrendingNowSection({super.key, required this.media, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        TitleSection(title: "Trending Now", center: true),
        TabBar(
          controller: homeController.tabController,
          indicatorColor: Colors.red,
          dividerColor: Colors.red.withOpacity(0.5),
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          isScrollable: false,
          physics: NeverScrollableScrollPhysics(),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Iconify(
                    Ph.music_note_duotone, size: 25,
                    color: (homeController.selectedTab.value == 0) ? accentColor : accentColorDark,
                  ),
                  Gap(8),
                  Text(
                    "Music",
                    style: TextStyle(
                      fontSize: 21,
                      color: (homeController.selectedTab.value == 0) ? accentColor : accentColorDark
                    )
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Iconify(
                    Ic.twotone_album, size: 25,
                    color: (homeController.selectedTab.value == 1) ? accentColor : accentColorDark,
                  ),
                  Gap(8),
                  Text(
                      "Album",
                      style: TextStyle(
                        fontSize: 21,
                        color: (homeController.selectedTab.value == 1) ? accentColor : accentColorDark
                    )
                  ),
                ],
              ),
            ),
          ]
        ),
        Gap(20),
        SizedBox(
          height: media.width/1.25,
          child: TabBarView(
            controller: homeController.tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              CarouselSlider.builder(
                itemCount: (homeController.home.value.trendingNow.songs.isEmpty)
                  ? 1
                  : homeController.home.value.trendingNow.songs.length,
                itemBuilder: (context, index, realIndex) {
                  if(homeController.home.value.trendingNow.songs.isEmpty) {
                    return ShimmerCard();
                  } else if(homeController.home.value.trendingNow.songs.length == 1) {
                    return SongCard(homeController.home.value.trendingNow.songs.first);
                  }
                  Song song = homeController.home.value.trendingNow.songs[index];
                  return SongCard(song);
                },
                options: CarouselOptions(
                  height: media.width/1.25,
                  autoPlay: true, autoPlayAnimationDuration: Duration(milliseconds: 700),
                  autoPlayInterval: Duration(seconds: 8),
                  initialPage: 0, enlargeCenterPage: true,
                  enableInfiniteScroll: (homeController.home.value.trendingNow.songs.length != 1)
                ),
              ),
              CarouselSlider.builder(
                  itemCount: (homeController.home.value.trendingNow.albums.isEmpty)
                    ? 1
                    : homeController.home.value.trendingNow.albums.length,
                  itemBuilder: (context, index, realIndex) {
                    if(homeController.home.value.trendingNow.albums.isEmpty) {
                      return ShimmerCard();
                    } else if(homeController.home.value.trendingNow.albums.length == 1) {
                      return AlbumCard(homeController.home.value.trendingNow.albums.first);
                    }
                    Album album = homeController.home.value.trendingNow.albums[index];
                    return AlbumCard(album);
                  },
                  options: CarouselOptions(
                    height: media.width/1.25,
                    autoPlay: true, autoPlayAnimationDuration: Duration(milliseconds: 700), autoPlayInterval: Duration(seconds: 8),
                    initialPage: 0, enlargeCenterPage: true,
                    enableInfiniteScroll: (homeController.home.value.trendingNow.albums.length != 1)
                  ),
                ),
            ],
          ),
        ),
      ],
    ));
  }
}