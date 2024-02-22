// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/services/home_view_api.dart';
import 'package:sonicity/src/services/navigation_controller.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/sections/hot_playlists_section.dart';
import 'package:sonicity/utils/sections/last_session_section.dart';
import 'package:sonicity/utils/sections/top_albums_section.dart';
import 'package:sonicity/utils/sections/top_charts_section.dart';
import 'package:sonicity/utils/sections/trending_now_section.dart';

class HomeView extends StatelessWidget{
  HomeView({super.key});

  final homeViewApi = Get.put(HomeViewApi());
  final scrollController = ScrollController();
  final padding = 0.obs;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Obx(
      () {
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
            drawer: Drawer(),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    _appBar(media),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 20),
                        TrendingNowSection(media: media, homeViewApi: homeViewApi),
                        SizedBox(height: 20),
                        TopChartsSection(media: media, homeViewApi: homeViewApi),
                        SizedBox(height: 20),
                        if(homeViewApi.lastSessionSprefs.isNotEmpty)
                        LastSessionSection(media: media, homeViewApi: homeViewApi),
                        SizedBox(height: 20),
                        TopAlbumsSection(media: media, homeViewApi: homeViewApi),
                        SizedBox(height: 20),
                        HotPlaylistSection(media: media, homeViewApi: homeViewApi),
                      ])
                    ),
                  ],
                ),
              ),
            ),
          )
        );
      }
    );
  }

  SliverAppBar _appBar(Size media) {
    return SliverAppBar(
      pinned: false, floating: true,
      toolbarHeight: 75,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.black87, surfaceTintColor: Colors.black87,
      leading: GestureDetector(
        onTap: () => Get.find<NavigationController>().openDrawer(),
        child: Icon(Icons.line_weight, color: Colors.white)
      ),
      leadingWidth: 30, titleSpacing: 10,
      title: Container(
        height: 60, width: media.width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF151515),
          border: Border.all(color: accentColor.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(50)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.search, size: 30, color: Colors.cyanAccent),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                "Songs, albums, genre or artists", overflow: TextOverflow.ellipsis, maxLines: 1,
                style: TextStyle(fontSize: 21, color: Colors.grey)
              ),
            )
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Icon(Icons.favorite_border, size: 30, color: Colors.grey.shade300)
        ),
        SizedBox(width: 8)
      ],
    );
  }
}
