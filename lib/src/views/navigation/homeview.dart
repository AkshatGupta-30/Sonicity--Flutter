// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:sonicity/src/controllers/homeview_controller.dart';
import 'package:sonicity/utils/sections/hot_playlists_section.dart';
import 'package:sonicity/utils/sections/last_session_section.dart';
import 'package:sonicity/utils/sections/top_albums_section.dart';
import 'package:sonicity/utils/sections/top_charts_section.dart';
import 'package:sonicity/utils/sections/trending_now_section.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/search_widget.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class HomeView extends StatelessWidget{
  HomeView({super.key});

  final controller = Get.put(HomeViewController());
  final scrollController = ScrollController();
  final padding = 0.obs;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    EdgeInsets padding = MediaQuery.paddingOf(context);
    return BackgroundGradientDecorator(
      child: Obx(() => CustomScrollView(
        controller: scrollController,
        slivers: [
          _appBar(context, media, padding),
          _content(media),
        ],
      )),
    );
  }

  SliverAppBar _appBar(BuildContext context, Size media, EdgeInsets padding) {
    return SliverAppBar(
      pinned: true, toolbarHeight: kToolbarHeight + padding.top/2,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Iconify(
            Uis.favorite, size: 30,
            color: (Theme.of(context).brightness == Brightness.light) ? Colors.yellow : Colors.yellowAccent
          )
        ),
        Gap(12)
      ],
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.25,
        titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        title: SafeArea(child: SearchContainer(media: media)),
        background: Image.asset(
          (Theme.of(context).brightness == Brightness.light) ? "assets/images/concertLight.jpg" : "assets/images/concertDark.jpg",
          fit: BoxFit.cover, filterQuality: FilterQuality.low
        ),
        stretchModes: [StretchMode.blurBackground],
      ),
    );
  }

  SliverToBoxAdapter _content(Size media) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Gap(20),
            TrendingNowSection(media: media, homeController: controller),
            Gap(20),
            TopChartsSection(media: media, topCharts: controller.home.value.topCharts),
            Gap(20),
            if(controller.home.value.lastSession.isNotEmpty)
              LastSessionSection(media: media, homeController: controller),
            Gap(20),
            TopAlbumsSection(media: media, topAlbums: controller.home.value.topAlbums),
            Gap(20),
            HotPlaylistSection(media: media, hotPlaylists: controller.home.value.hotPlaylists),
          ]
        ),
      )
    );
  }
}