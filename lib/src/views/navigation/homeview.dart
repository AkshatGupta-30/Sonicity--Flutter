// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:sonicity/src/controllers/homeview_controller.dart';
import 'package:sonicity/src/controllers/navigation_controller.dart';
import 'package:sonicity/utils/sections/hot_playlists_section.dart';
import 'package:sonicity/utils/sections/last_session_section.dart';
import 'package:sonicity/utils/sections/top_albums_section.dart';
import 'package:sonicity/utils/sections/top_charts_section.dart';
import 'package:sonicity/utils/sections/trending_now_section.dart';
import 'package:sonicity/utils/widgets/search_widgte.dart';

class HomeView extends StatelessWidget{
  HomeView({super.key});

  final homeViewController = Get.put(HomeViewController());
  final scrollController = ScrollController();
  final padding = 0.obs;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    EdgeInsets safeArea = MediaQuery.paddingOf(context);
    return Obx(
      () {
        return Scaffold(
          backgroundColor: Colors.black,
          drawer: Drawer(),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                _appBar(media, safeArea),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Gap(20),
                        TrendingNowSection(media: media, homeController: homeViewController),
                        Gap(20),
                        TopChartsSection(media: media, homeController: homeViewController),
                        Gap(20),
                        if(homeViewController.home.value.lastSession.isNotEmpty)
                          LastSessionSection(media: media, homeController: homeViewController),
                        Gap(20),
                        TopAlbumsSection(media: media, homeController: homeViewController),
                        Gap(20),
                        HotPlaylistSection(media: media, homeController: homeViewController),
                      ]
                    ),
                  )
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  SliverAppBar _appBar(Size media, EdgeInsets safeArea) {
    List<String> concertLinkList = [
      "assets/images/concert2.jpg",
      "assets/images/concert3.jpg",
      "assets/images/concert6.jpg",
      "assets/images/concert8.jpg",
    ];
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 75, backgroundColor: Colors.transparent,
      shadowColor: Colors.black87, surfaceTintColor: Colors.black87,
      leading: GestureDetector(
        onTap: () => Get.find<NavigationController>().openDrawer(),
        child: Icon(Icons.line_weight, color: Colors.white)
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Iconify(Uis.favorite, size: 30, color: Colors.yellowAccent)
        ),
        Gap(8)
      ],
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.25,
        titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        title: SearchContainer(media: media),
        background: Image.asset(concertLinkList[Random().nextInt(concertLinkList.length)], fit: BoxFit.fill),
        stretchModes: [StretchMode.blurBackground],
      ),
    );
  }
}