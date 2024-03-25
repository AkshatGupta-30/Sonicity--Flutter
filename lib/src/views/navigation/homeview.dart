
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

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
      leading: DrawerButton().build(context),
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
          (Theme.of(context).brightness == Brightness.light)
              ? "assets/images/homeCover/concertLight.jpg"
              : "assets/images/homeCover/concertDark.jpg",
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
            TrendingNowSection(media: media),
            Gap(20),
            TopChartsSection(media: media),
            MyPlaylistsSection(media: media,),
            LastSessionSection(media: media),
            Gap(20),
            TopAlbumsSection(media: media),
            Gap(20),
            HotPlaylistSection(media: media),
          ]
        ),
      )
    );
  }
}