// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/test_service.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/widgets/title_section.dart';

class TrendingNowSection extends StatefulWidget {
  final Size media;
  final TestApi testApi;

  const TrendingNowSection({super.key, required this.media, required this.testApi});

  @override
  State<TrendingNowSection> createState() => _TrendingNowSectionState();
}

class _TrendingNowSectionState extends State<TrendingNowSection> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          children: [
            TitleSection(title: "Trending Now", center: true),
            TabBar(
              controller: tabController,
              indicatorColor: Colors.redAccent,
              dividerColor: Colors.transparent, dividerHeight: 0,
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              labelColor: accentColor.withOpacity(0.75), unselectedLabelColor: accentColorDark,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.music_note, size: 25),
                      SizedBox(width: 8),
                      Text("Music", style: TextStyle(fontSize: 21))
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.album, size: 25),
                      SizedBox(width: 8),
                      Text("Album", style: TextStyle(fontSize: 21))
                    ],
                  ),
                )
              ]
            ),
            SizedBox(height: 20),
            SizedBox(
              height: widget.media.width/1.25,
              child: TabBarView(
                controller: tabController,
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.testApi.songsList.length,
                    itemBuilder: (context, index, realIndex) {
                      Song song = Song.fromJson(widget.testApi.songsList[index]);
                      return SongCell(song: song);
                    },
                    options: CarouselOptions(
                      height: widget.media.width/1.25,
                      autoPlay: true, autoPlayAnimationDuration: Duration(milliseconds: 700), autoPlayInterval: Duration(seconds: 8),
                      initialPage: 0, enlargeCenterPage: true,
                    ),
                  ),
                  CarouselSlider.builder(
                    itemCount: widget.testApi.albumList.length,
                    itemBuilder: (context, index, realIndex) {
                      Album album = Album.fromShortJson(widget.testApi.albumList[index]);
                      return AlbumCell(album: album);
                    },
                    options: CarouselOptions(
                      height: widget.media.width/1.25,
                      autoPlay: true, autoPlayAnimationDuration: Duration(milliseconds: 700), autoPlayInterval: Duration(seconds: 8),
                      initialPage: 0, enlargeCenterPage: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}