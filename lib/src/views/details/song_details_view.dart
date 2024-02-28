// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ant_design.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/song_detail_controller.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
import 'package:sonicity/utils/sections/download_url_section.dart';
import 'package:sonicity/utils/widgets/album_widget.dart';
import 'package:sonicity/utils/widgets/artist_widgte.dart';
import 'package:super_string/super_string.dart';

class SongDetailsView extends StatelessWidget {
  final String songId;
  SongDetailsView(this.songId, {super.key});

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: GetBuilder<SongDetailController>(
          init: SongDetailController(songId),
          builder: (controller) {
            return Obx(
              () {
                Song song = controller.song.value;
                if(song.isEmpty()) {
                  return Center(
                    child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                  );
                }
                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      Obx(
                        () {
                          return SliverAppBar(
                            pinned: true, floating: false, snap: false,
                            toolbarHeight: kBottomNavigationBarHeight,
                            shadowColor: Colors.black87, surfaceTintColor: Colors.black87, backgroundColor: Colors.grey.shade900,
                            leading: BackButton(color: Colors.white),
                            expandedHeight: 360,
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true, expandedTitleScale: 1.5,
                              stretchModes: [StretchMode.blurBackground],
                              titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: 60),
                              title: SizedBox(
                                width: media.width/1.4,
                                child: Text(
                                  song.name, maxLines: 1, overflow: TextOverflow.ellipsis,  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                              background: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: song.image.highQuality, fit: BoxFit.fill,
                                    width: 400, height: 400,
                                    placeholder: (context, url) {
                                      return Image.asset("assets/images/appLogo150x150.png", fit: BoxFit.fill);
                                    },
                                    errorWidget: (context, url, error) {
                                      return Image.asset("assets/images/appLogo150x150.png", fit: BoxFit.fill);
                                    },
                                  ),
                                  Container(
                                    width: media.width, height: 400,
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
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ToDoView(text: "Song in starred"));
                                },
                                child: Iconify(Uis.favorite, size: 30, color: Colors.yellowAccent)
                              ),
                              Gap(8)
                            ],
                            bottom: TabBar(
                              controller: controller.tabController,
                              indicatorColor: Colors.red,
                              dividerColor: Colors.red.withOpacity(0.5),
                              overlayColor: MaterialStatePropertyAll(Colors.transparent),
                              splashFactory: NoSplash.splashFactory,
                              isScrollable: false,
                              physics: NeverScrollableScrollPhysics(),
                              tabs: [
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Iconify(
                                        IconParkTwotone.doc_detail, size: 25,
                                        color: (controller.selectedTab.value == 0) ? accentColor : accentColorDark,
                                      ),
                                      Gap(8),
                                      Text(
                                        "Details",
                                        style: TextStyle(
                                          fontSize: 21,
                                          color: (controller.selectedTab.value == 0) ? accentColor : accentColorDark
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Iconify(
                                        Ic.twotone_lyrics, size: 25,
                                        color: (controller.selectedTab.value == 1) ? accentColor : accentColorDark,
                                      ),
                                      Gap(8),
                                      Text(
                                        "Lyrics",
                                        style: TextStyle(
                                          fontSize: 21,
                                          color: (controller.selectedTab.value == 1) ? accentColor : accentColorDark
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          );
                        }
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: controller.tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        child: ListView(
                          children: [
                            _divide(),
                            _head("Name"),
                            _detail(song.name),
                            _divide(),
                            _head("From Album"),
                            _albumSection(song.album!),
                            _divide(),
                            _head("Contributed Artists"),
                            _artistSection(song.artists!),
                            _divide(),
                            _head("Duration"),
                            _detail("${song.duration} seconds"),
                            _divide(),
                            _head("Language"),
                            _detail(song.language!.capitalizeFirst!),
                            _divide(),
                            _head("Release Date"),
                            _detail(song.releaseDate!),
                            _divide(),
                            _head("Cover Image Url"),
                            CoverImageSection(image: song.image),
                            _divide(),
                            _head("Download Song"),
                            DownloadUrlSection(downloadUrl: song.downloadUrl),
                            _divide(),
                          ],
                        ),
                      ),
                      Container(
                        child: (!controller.song.value.hasLyrics)
                          ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Iconify(Ic.twotone_error, color: Colors.redAccent, size: 50),
                                    Text(
                                      "This song doesn't have any available lyrics.", textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.redAccent, fontSize: 25),
                                    )
                                  ]
                                ),
                              ),
                            )
                          )
                          : ListView(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 21),
                            children: [
                              Text(
                                controller.lyrics.value.snippet.title(), textAlign: TextAlign.center,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                              Gap(5),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.defaultDialog(
                                        backgroundColor: Colors.grey.shade800,
                                        title: "© Copyright", titleStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
                                        content: SelectableText(
                                          controller.lyrics.value.copyright, textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.grey.shade300, fontSize: 18)
                                        )
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(child: Iconify(Ic.twotone_copyright, color: Colors.blue, size: 21)),
                                          TextSpan(
                                            text: " Copyright",
                                            style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w500)
                                          )
                                        ]
                                      ),
                                    )
                                  ),
                                ],
                              ),
                              SelectableText.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  text: controller.lyrics.value.lyrics,
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 21)
                                ),
                              ),
                            ],
                          ),
                      )
                    ],
                  ),
                );
              }
            );
          }
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        duration: Duration(milliseconds: 250),
        distance: 100.0,
        type: ExpandableFabType.fan,
        pos: ExpandableFabPos.right,
        childrenOffset: Offset(0,0),
        fanAngle: 90,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: Iconify(IconParkTwotone.more_four, color: accentColor),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: accentColor,
          backgroundColor: accentColorDark,
          shape: CircleBorder(),
          angle: 3.14 * 2,
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed, Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: Iconify(AntDesign.close_circle_twotone, size: 40, color: accentColor),
            );
          },
        ),
        overlayStyle: ExpandableFabOverlayStyle(blur: 5),
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.to(() => ToDoView(text: "Add this song to playlist"));
            },
            tooltip: "Add to Playlist",
            backgroundColor: accentColorDark, shape: CircleBorder(),
            child: Iconify(Tabler.playlist_add, color: accentColor, size: 40)
          ),
          FloatingActionButton(
            onPressed: () {
              Get.to(() => ToDoView(text: "Play this song now"));
            },
            tooltip: "Play Now",
            backgroundColor: accentColorDark, shape: CircleBorder(),
            child: Iconify(Ic.twotone_play_arrow, color: accentColor, size: 40)
          ),
          FloatingActionButton(
            onPressed: () {
              Get.to(() => ToDoView(text: "Add this song to queue"));
            },
            tooltip: "Add to Queue",
            backgroundColor: accentColorDark, shape: CircleBorder(),
            child: Iconify(Ph.queue_bold, color: accentColor, size: 40)
          ),
        ],
      ),
    );
  }

  Divider _divide() {
    return Divider(color: Colors.white30);
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

  Widget _albumSection(Album album) {
    return AlbumCell(album: album, subtitle: "");
  }

  Widget _artistSection(List<Artist> artists) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          Artist artist = artists[index];
          return ArtistCell(artist: artist, subtitle: "");
        }
      ),
    );
  }
}