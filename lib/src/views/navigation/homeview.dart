// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/test_service.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/widgets/title_section.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final testApi = Get.put(TestApi());

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
                Obx(
                  () {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 20),
                        TitleSection(title: "Trending Now"),
                        SizedBox(
                          height: 280, width: double.maxFinite,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                            itemCount: testApi.songsList.length,
                            itemBuilder: (context, index) {
                              Song song = Song.fromJson(testApi.songsList[index]);
                              return SongTile(song: song);
                            },
                          ),
                        )
                      ])
                    );
                  }
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

