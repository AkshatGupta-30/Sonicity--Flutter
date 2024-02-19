// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/test_service.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/widgets/title_section.dart';

class HomeView extends StatefulWidget{
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController tabController;
  final homeController = Get.put(HomeController());

  final testApi = Get.put(TestApi());

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  toolbarHeight: kBottomNavigationBarHeight,
                  backgroundColor: Colors.transparent, shadowColor: Colors.transparent, surfaceTintColor: Colors.transparent,
                  expandedHeight: kBottomNavigationBarHeight * 2,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1, centerTitle: true,
                    titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    title: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      height: kBottomNavigationBarHeight,
                      decoration: BoxDecoration(
                        color: Color(0xFF151515),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.search, size: 35, color: Colors.cyanAccent),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Songs, albums, genre or artists", overflow: TextOverflow.ellipsis, maxLines: 1,
                              style: TextStyle(fontSize: 24, color: Colors.grey)
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 20),
                    TitleSection(title: "Trending Now", center: true, size: 27,),
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
                      height: media.width/1.25,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          CarouselSlider.builder(
                            itemCount: testApi.songsList.length,
                            itemBuilder: (context, index, realIndex) {
                              Song song = Song.fromJson(testApi.songsList[index]);
                              return SongTile(song: song);
                            },
                            options: CarouselOptions(
                              height: media.width/1.25,
                              autoPlay: true, autoPlayAnimationDuration: Duration(seconds: 1), autoPlayInterval: Duration(seconds: 6),
                              initialPage: 0, enlargeCenterPage: true,
                            ),
                          ),
                          CarouselSlider.builder(
                            itemCount: testApi.albumList.length,
                            itemBuilder: (context, index, realIndex) {
                              Album album = Album.fromShortJson(testApi.albumList[index]);
                              return AlbumTile(album: album);
                            },
                            options: CarouselOptions(
                              height: media.width/1.25,
                              autoPlay: true, autoPlayAnimationDuration: Duration(seconds: 1), autoPlayInterval: Duration(seconds: 6),
                              initialPage: 0, enlargeCenterPage: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ])
                ),
                SliverFixedExtentList(
                  itemExtent: 20,
                  delegate: SliverChildBuilderDelegate((context, index) => TitleSection(title: "title")),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

class HomeController extends GetxController {
  final music = true.obs;
  final musicEndIndex = 0.obs;
  final currentPage = 0.obs;
  final carouselController = CarouselController().obs;
}