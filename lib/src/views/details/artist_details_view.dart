import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/artist_detail_controller.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class ArtistDetailsView extends StatelessWidget {
  ArtistDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return GetBuilder(
      init: ArtistDetailController(Get.arguments),
      builder: (controller) {
        return Scaffold(
          body: BackgroundGradientDecorator(
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
                  return [_appBar(context, selectedTab, media, artist, controller)];
                },
                body: TabBarView(
                  controller: controller.tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <ListView>[
                    _songsTab(controller),
                    _albumsTab(controller),
                    _infoTab(context, artist),
                  ],
                ),
              );
            }),
          ),
          bottomNavigationBar: Obx(() {
            int selectedTab = controller.selectedTab.value;
            return TabBar(
              controller: controller.tabController,
              dividerColor: Colors.transparent,
              isScrollable: false, physics: NeverScrollableScrollPhysics(),
              tabs: [
                Tab(
                  icon: Obx(() => Iconify(
                    Ph.music_notes_simple_fill, size: 25,
                    color: (selectedTab == 0 || selectedTab == 1)
                      ? Get.find<SettingsController>().getAccent
                      : Get.find<SettingsController>().getAccentDark,
                  )),
                  text: "Songs",
                ),
                Tab(
                  icon: Obx(() => Iconify(
                    Ic.sharp_album, size: 25,
                    color: (controller.selectedTab.value == 1)
                      ? Get.find<SettingsController>().getAccent
                      : Get.find<SettingsController>().getAccentDark,
                  )),
                  text: "Albums",
                ),
                Tab(
                  icon: Obx(() => Iconify(
                    IconParkTwotone.doc_detail, size: 25,
                    color: (controller.selectedTab.value == 2)
                      ? Get.find<SettingsController>().getAccent
                      : Get.find<SettingsController>().getAccentDark,
                  )),
                  text: "Info",
                ),
              ]
            );
          }),
        );
      }
    );
  }

  SliverAppBar _appBar(BuildContext context, int selectedTab, Size media, Artist artist, ArtistDetailController controller) {
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      leading: BackButton(),
      expandedHeight: (selectedTab == 0 || selectedTab == 1) ? 390 : 360,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: (selectedTab == 0 || selectedTab == 1) ? 70 : 14),
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
              width: 400, height: 390,
              placeholder: (context, url) {
                return Image.asset("assets/images/appLogo150x150.png", fit: BoxFit.fill);
              },
              errorWidget: (context, url, error) {
                return Image.asset("assets/images/appLogo150x150.png", fit: BoxFit.fill);
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
      actions: [
        SpiderReport(color: Colors.redAccent),
        Gap(10),
        GestureDetector(
          onTap: () {
            Get.to(() => ToDoView(text: "Song in starred"));
          },
          child: Iconify(
            Uis.favorite, size: 30,
            color: (Theme.of(context).brightness == Brightness.light) ? Colors.yellow : Colors.yellowAccent,
          )
        ),
        Gap(8)
      ],
      bottom: (selectedTab == 0 || selectedTab == 1)
        ? PreferredSize(
          preferredSize: Size(double.maxFinite, kToolbarHeight),
          child: Container(
            height: kToolbarHeight,
            color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Divider(),
                Spacer(),
                if(selectedTab == 0)
                  Row( 
                    children: [
                      Gap(20),
                      Text("${controller.songCount} Songs", style: Theme.of(context).textTheme.bodyLarge),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text("Shuffle", style: Theme.of(context).textTheme.labelMedium),
                                Iconify(Ic.twotone_shuffle, size: 25),
                              ],
                            ),
                            Gap(5),
                            Container(height: 30, width: 1, color: Colors.white38),
                            Gap(8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Iconify(
                                Ic.twotone_play_arrow, size: 27,
                                color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
                              ),
                            ),
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
                          ],
                        ),
                      ),
                      Gap(10)
                    ],
                  ),
                if(selectedTab == 1)
                  Container(
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
                  ),
                Spacer()
              ],
            ),
          ),
        )
        : null,
    );
  }

  ListView _songsTab(ArtistDetailController controller) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: (controller.songsIsLoading.value && controller.songCount.value != controller.songList.length)
        ? controller.songList.length + 1
        : controller.songList.length,
      itemBuilder: (context, index)  {
        if(index < controller.songList.length) {
          Song song = controller.songList[index];
          return SongsTile(song);
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