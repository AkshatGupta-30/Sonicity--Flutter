import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class ArtistDetailsView extends StatelessWidget {
  ArtistDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return GetBuilder(
      init: ArtistDetailController(Get.arguments),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BackgroundGradientDecorator(
                child: Obx(() {
                  int selectedTab = controller.selectedTab.value;
                  Artist artist = controller.artist.value;
                  if(artist.isEmpty()) {
                    return Center(
                      child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                    );
                  }
                  return NestedScrollView(
                    controller: controller.scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        _appBar(context, selectedTab, media, artist, controller),
                        _tabBar(context, controller),
                        _summaryHeader(context, artist, controller),
                      ];
                    },
                    body: TabBarView(
                      controller: controller.tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _songsTab(controller),
                        _albumsTab(controller),
                        _infoTab(context, artist),
                      ],
                    ),
                  );
                }),
              ),
              MiniPlayerView()
            ],
          ),
        );
      }
    );
  }

  SliverAppBar _appBar(BuildContext context, int selectedTab, Size media, Artist artist, ArtistDetailController controller) {
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      leading: BackButton(),
      expandedHeight: 360,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        title: FittedBox(
          child: Text(
            artist.name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        background: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: artist.image!.highQuality, fit: BoxFit.fill,
              width: media.width, height: 390,
              placeholder: (context, url) {
                return Image.asset("assets/images/artistCover/artistCover500x500.jpg", fit: BoxFit.fill);
              },
              errorWidget: (context, url, error) {
                return Image.asset("assets/images/artistCover/artistCover500x500.jpg", fit: BoxFit.fill);
              },
            ),
            Container(
              width: media.width, height: 390,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: (Theme.of(context).brightness == Brightness.light)
                    ? [Colors.white.withOpacity(0), Colors.white.withOpacity(0.75)]
                    : [Colors.black.withOpacity(0), Colors.black.withOpacity(0.75)],
                  begin: Alignment.center, end: Alignment.bottomCenter,
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverPinnedHeader _tabBar(BuildContext context, ArtistDetailController controller) {
    return SliverPinnedHeader(
      child: Obx(() {
        int selectedTab = controller.selectedTab.value;
        return Container(
          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          child: TabBar(
            controller: controller.tabController,
            dividerColor: Colors.transparent,
            isScrollable: false, physics: NeverScrollableScrollPhysics(),
            tabs: [
              Tab(
                child: Row(
                  children: [
                    Iconify(
                      Ph.music_notes_simple_fill, size: 24,
                      color: (selectedTab == 0)
                        ? Get.find<SettingsController>().getAccent
                        : Get.find<SettingsController>().getAccentDark,
                    ),
                    Gap(5),
                    Text("Songs", style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Iconify(
                      Ic.sharp_album, size: 24,
                      color: (controller.selectedTab.value == 1)
                        ? Get.find<SettingsController>().getAccent
                        : Get.find<SettingsController>().getAccentDark,
                    ),
                    Gap(5),
                    Text("Albums", style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Iconify(
                      IconParkTwotone.doc_detail, size: 24,
                      color: (controller.selectedTab.value == 2)
                        ? Get.find<SettingsController>().getAccent
                        : Get.find<SettingsController>().getAccentDark,
                    ),
                    Gap(5),
                    Text("Info", style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
            ]
          ),
        );
      }),
    );
  }

  SliverPinnedHeader _summaryHeader(BuildContext context, Artist artist, ArtistDetailController controller) {
    return SliverPinnedHeader(
      child: Obx(
        () {
          if(controller.selectedTab.value == 2) return SizedBox();
          return Container(
            height: kToolbarHeight, padding: EdgeInsets.zero,
            color: (Theme.of(context).brightness == Brightness.light) ? Colors.white : Colors.black,
            child: Column(
              children: [
                (controller.selectedTab.value == 0)
                    ? Row( 
                      children: [
                        Gap(20),
                        Text("${controller.songCount} Songs", style: Theme.of(context).textTheme.bodyLarge),
                        Spacer(),
                        ShuffleNPlay(controller.songList),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: () => controller.sort(SortType.name, Sort.asc),
                                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
                              ),
                              PopupMenuItem(
                                onTap: () => controller.sort(SortType.name, Sort.dsc),
                                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
                              ),
                              PopupMenuItem(
                                onTap: () => controller.sort(SortType.duration, Sort.asc),
                                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Duration Asc")
                              ),
                              PopupMenuItem(
                                onTap: () => controller.sort(SortType.duration, Sort.dsc),
                                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Duration Desc")
                              ),
                              PopupMenuItem(
                                onTap: () => controller.sort(SortType.year, Sort.asc),
                                child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Year Asc")
                              ),
                              PopupMenuItem(
                                onTap: () => controller.sort(SortType.year, Sort.dsc),
                                child: PopUpButtonRow(icon: Mdi.sort_calendar_descending, label: "Year Desc")
                              ),
                            ];
                          },
                          icon: Iconify(MaterialSymbols.sort_rounded,),
                          position: PopupMenuPosition.under,
                          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        Gap(10)
                      ],
                    )
                    : SizedBox(),
                (controller.selectedTab.value == 1)
                    ? Container(
                      width: double.maxFinite, alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text("${controller.albumCount} Albums", style: Theme.of(context).textTheme.bodyLarge),
                          Spacer(),
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  onTap: () => controller.sort(SortType.name, Sort.asc, songs: false),
                                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
                                ),
                                PopupMenuItem(
                                  onTap: () => controller.sort(SortType.name, Sort.dsc, songs: false),
                                  child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
                                ),
                                PopupMenuItem(
                                  onTap: () => controller.sort(SortType.songCount, Sort.asc, songs: false),
                                  child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Song Count Asc")
                                ),
                                PopupMenuItem(
                                  onTap: () => controller.sort(SortType.songCount, Sort.dsc, songs: false),
                                  child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Song Count Desc")
                                ),
                                PopupMenuItem(
                                  onTap: () => controller.sort(SortType.year, Sort.asc, songs: false),
                                  child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Year Asc")
                                ),
                                PopupMenuItem(
                                  onTap: () => controller.sort(SortType.year, Sort.dsc, songs: false),
                                  child: PopUpButtonRow(icon: Mdi.sort_calendar_descending, label: "Year Desc")
                                ),
                              ];
                            },
                            icon: Iconify(MaterialSymbols.sort_rounded,),
                            position: PopupMenuPosition.under,
                            color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          Gap(10)
                        ],
                      ),
                    )
                    : SizedBox(),
                Spacer()
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _songsTab(ArtistDetailController controller) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: (controller.songsIsLoading.value && controller.songCount.value != controller.songList.length)
        ? controller.songList.length + 1
        : controller.songList.length,
      itemBuilder: (context, index)  {
        if(index < controller.songList.length) {
          Song song = controller.songList[index];
          return SongTile(song);
        } else {
          return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
        }
      }
    );
  }

  ListView _albumsTab(ArtistDetailController controller) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: (controller.albumsIsLoading.value && controller.albumCount.value != controller.albumList.length)
        ? controller.albumList.length + 1
        : controller.albumList.length,
      itemBuilder: (context, index)  {
        if(index < controller.albumList.length) {
          Album album = controller.albumList[index];
          return AlbumTile(album, subtitle: "${album.songCount!} Songs");
        } else {
          return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
        }
      }
    );
  }

  ListView _infoTab(BuildContext context, Artist artist) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      children: [
        Divider(),
        _head(context, "Name"),
        _detail(context, artist.name),
        Divider(),
        _head(context, "Dominant Language"),
        _detail(context, artist.dominantLanguage!),
        Divider(),
        _head(context, "Dominant Type"),
        _detail(context, artist.dominantType!),
        Divider(),
        if(artist.dob != null && artist.dob!.isNotEmpty)
          _dobSection(context, artist.dob!),
        if(artist.fb != null && artist.fb!.isNotEmpty)
          _fbSection(context, artist.fb!),
        if(artist.twitter != null && artist.twitter!.isNotEmpty)
          _twitterSection(context, artist.twitter!),
        if(artist.wiki != null && artist.wiki!.isNotEmpty)
          _wikiSection(context, artist.wiki!),
        _head(context, "Cover Image Url"),
        CoverImageSection(image: artist.image!),
        Divider(),
      ],
    );
  }

  Text _head(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall);
  }

  Widget _detail(BuildContext context, String text, {bool isSelectable = false}) {
    if(isSelectable) {
      return SelectableText(text, style: Theme.of(context).textTheme.labelLarge);
    }
    return Text(text, style: Theme.of(context).textTheme.labelLarge);
  }

  Column _dobSection(BuildContext context, String dob) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head(context, "Date of birth"),
        _detail(context, dob),
        Divider(),
      ],
    );
  }

  Column _fbSection(BuildContext context, String fb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head(context, "Facebook"),
        _detail(context, fb),
        Divider(),
      ],
    );
  }

  Column _twitterSection(BuildContext context, String twit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head(context, "Twitter"),
        _detail(context, twit),
        Divider(),
      ],
    );
  }

  Column _wikiSection(BuildContext context, String wiki) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head(context, "Wikipedia"),
        _detail(context, wiki),
      ],
    );
  }
}