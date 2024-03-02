// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/artist_detail_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
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
                  return [_appBar(selectedTab, media, artist, controller)];
                },
                body: TabBarView(
                  controller: controller.tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <ListView>[
                    _songsTab(controller),
                    _albumsTab(controller),
                    _infoTab(artist),
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
                  icon: Iconify(
                    Ph.music_notes_simple_fill, size: 25,
                    color: (selectedTab == 0 || selectedTab == 1) ? accentColor : accentColorDark,
                  ),
                  text: "Songs",
                ),
                Tab(
                  icon: Iconify(
                    Ic.sharp_album, size: 25,
                    color: (controller.selectedTab.value == 1) ? accentColor : accentColorDark,
                  ),
                  text: "Albums",
                ),
                Tab(
                  icon: Iconify(
                    IconParkTwotone.doc_detail, size: 25,
                    color: (controller.selectedTab.value == 2) ? accentColor : accentColorDark,
                  ),
                  text: "Info",
                ),
              ]
            );
          }),
        );
      }
    );
  }

  SliverAppBar _appBar(int selectedTab, Size media, Artist artist, ArtistDetailController controller) {
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      leading: BackButton(),
      expandedHeight: (selectedTab == 0 || selectedTab == 1) ? 390 : 360,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: (selectedTab == 0 || selectedTab == 1) ? 70 : 14),
        title: FittedBox(
          child: Text(artist.name, maxLines: 1, overflow: TextOverflow.ellipsis,  textAlign: TextAlign.center),
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
                  colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.75)],
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
          child: Iconify(Uis.favorite, size: 30, color: Colors.yellowAccent)
        ),
        Gap(8)
      ],
      bottom: (selectedTab == 0 || selectedTab == 1)
        ? PreferredSize(
          preferredSize: Size(double.maxFinite, kToolbarHeight),
          child: Container(
            height: kToolbarHeight, color: Colors.grey.shade900,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Divider(),
                Spacer(),
                if(selectedTab == 0)
                  Row( 
                    children: [
                      Gap(20),
                      Text(
                        "${controller.songCount} Songs",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
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
                                Text(
                                  "Shuffle",
                                  style: TextStyle(color: Colors.grey.shade300, fontSize: 21),
                                ),
                                Iconify(Ic.twotone_shuffle, color: Colors.grey.shade300, size: 25),
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
                              child: Iconify(Ic.twotone_play_arrow, color: Colors.grey.shade300, size: 27),
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
                              icon: Iconify(MaterialSymbols.sort_rounded, color: Colors.white),
                              position: PopupMenuPosition.under, color: Colors.grey.shade900,
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
                        Text(
                          "${controller.albumCount} Albums",
                          style: TextStyle(color: Colors.white, fontSize: 21),
                        ),
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
                          icon: Iconify(MaterialSymbols.sort_rounded, color: Colors.white),
                          position: PopupMenuPosition.under, color: Colors.grey.shade900,
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

  ListView _infoTab(Artist artist) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      children: [
        Divider(),
        _head("Name"),
        _detail(artist.name),
        Divider(),
        _head("Dominant Language"),
        _detail(artist.dominantLanguage!),
        Divider(),
        _head("Dominant Type"),
        _detail(artist.dominantType!),
        Divider(),
        if(artist.dob != null && artist.dob!.isNotEmpty)
          _dobSection(artist.dob!),
        if(artist.fb != null && artist.fb!.isNotEmpty)
          _fbSection(artist.fb!),
        if(artist.twitter != null && artist.twitter!.isNotEmpty)
          _twitterSection(artist.twitter!),
        if(artist.wiki != null && artist.wiki!.isNotEmpty)
          _wikiSection(artist.wiki!),
        _head("Cover Image Url"),
        CoverImageSection(image: artist.image!),
        Divider(),
      ],
    );
  }

  Text _head(String text) {
    TextStyle style = TextStyle(color: Colors.grey.shade400, fontSize: 21);
    return Text(text, style: style);
  }

  Widget _detail(String text, {bool isSelectable = false}) {
    TextStyle style = TextStyle(color: Colors.white, fontSize: 25);
    if(isSelectable) {
      return SelectableText(text, style: style);
    }
    return Text(text, style: style);
  }

  Column _dobSection(String dob) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head("Date of birth"),
        _detail(dob),
        Divider(),
      ],
    );
  }

  Column _fbSection(String fb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head("Facebook"),
        _detail(fb),
        Divider(),
      ],
    );
  }

  Column _twitterSection(String twit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head("Twitter"),
        _detail(twit),
        Divider(),
      ],
    );
  }

  Column _wikiSection(String wiki) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head("Wikipedia"),
        _detail(wiki),
      ],
    );
  }
}