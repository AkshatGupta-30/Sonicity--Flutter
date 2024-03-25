import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class TrendingNowSection extends StatelessWidget {
  final Size media;
  TrendingNowSection({super.key, required this.media});

  final controller = Get.find<HomeViewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        TitleSection(title: "Trending Now", center: true),
        TabBar(
          controller: controller.tabController,
          isScrollable: false,
          physics: NeverScrollableScrollPhysics(),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Iconify(
                    Ph.music_note_duotone, size: 25,
                    color: (controller.selectedTab.value == 0)
                      ? Get.find<SettingsController>().getAccent
                      : Get.find<SettingsController>().getAccentDark,
                  )),
                  Gap(8),
                  Obx(() => Text(
                    "Music",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: (controller.selectedTab.value == 0)
                        ? Get.find<SettingsController>().getAccent
                        : Get.find<SettingsController>().getAccentDark
                    )),
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Iconify(
                    Ic.twotone_album, size: 25,
                    color: (controller.selectedTab.value == 1)
                      ? Get.find<SettingsController>().getAccent
                      : Get.find<SettingsController>().getAccentDark,
                  )),
                  Gap(8),
                  Obx(() => Text(
                    "Album",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: (controller.selectedTab.value == 1)
                        ? Get.find<SettingsController>().getAccent
                        : Get.find<SettingsController>().getAccentDark
                    )),
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
            controller: controller.tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <CarouselSlider>[
              CarouselSlider.builder(
                itemCount: (controller.trendingNow.value.songs.isEmpty)
                  ? 1
                  : controller.trendingNow.value.songs.length,
                itemBuilder: (context, index, realIndex) {
                  if(controller.trendingNow.value.songs.isEmpty) {
                    return ShimmerCard();
                  } else if(controller.trendingNow.value.songs.length == 1) {
                    return SongCard(controller.trendingNow.value.songs.first);
                  }
                  Song song = controller.trendingNow.value.songs[index];
                  return SongCard(song);
                },
                options: CarouselOptions(
                  height: media.width/1.25,
                  autoPlay: true, autoPlayAnimationDuration: Duration(milliseconds: 700),
                  autoPlayInterval: Duration(seconds: 8),
                  initialPage: 0, enlargeCenterPage: true,
                  enableInfiniteScroll: (controller.trendingNow.value.songs.length != 1)
                ),
              ),
              CarouselSlider.builder(
                  itemCount: (controller.trendingNow.value.albums.isEmpty)
                    ? 1
                    : controller.trendingNow.value.albums.length,
                  itemBuilder: (context, index, realIndex) {
                    if(controller.trendingNow.value.albums.isEmpty) {
                      return ShimmerCard();
                    } else if(controller.trendingNow.value.albums.length == 1) {
                      return AlbumCard(controller.trendingNow.value.albums.first);
                    }
                    Album album = controller.trendingNow.value.albums[index];
                    return AlbumCard(album);
                  },
                  options: CarouselOptions(
                    height: media.width/1.25,
                    autoPlay: true, autoPlayAnimationDuration: Duration(milliseconds: 700), autoPlayInterval: Duration(seconds: 8),
                    initialPage: 0, enlargeCenterPage: true,
                    enableInfiniteScroll: (controller.trendingNow.value.albums.length != 1)
                  ),
                ),
            ],
          ),
        ),
      ],
    ));
  }
}