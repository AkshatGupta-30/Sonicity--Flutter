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
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/playlist_detail_controller.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class PlaylistDetailsView extends StatelessWidget {
  PlaylistDetailsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
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
        child: GetBuilder(
          init: PlaylistDetailController(Get.arguments),
          builder: (controller) {
            return Obx(() {
              Playlist playlist = controller.playlist.value;
              if(playlist.isEmpty()) {
                return Center(
                  child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                );
              }
              return CustomScrollView(
                slivers: [
                  _appBar(media, playlist, controller),
                  _playlistSongs(playlist),
                ],
              );
            });
          }
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _floatingActionButton(),
    );
  }

  SliverAppBar _appBar(Size media, Playlist playlist, PlaylistDetailController controller) {
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      toolbarHeight: kBottomNavigationBarHeight,
      shadowColor: Colors.black87, surfaceTintColor: Colors.black87, backgroundColor: Colors.grey.shade900,
      leading: BackButton(color: Colors.white),
      expandedHeight: 400,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 20, right: 20, bottom: 75),
        title: SizedBox(
          width: media.width/1.4,
          child: Text(
            playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        background: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: playlist.image.highQuality, fit: BoxFit.fill,
              width: double.maxFinite, height: 380,
              placeholder: (context, url) {
                return Image.asset("assets/images/appLogo150x150.png", fit: BoxFit.fill);
              },
              errorWidget: (context, url, error) {
                return Image.asset("assets/images/appLogo150x150.png", fit: BoxFit.fill);
              },
            ),
            Container(
              width: media.width, height: 420,
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
      ],
      bottom: PreferredSize(
        preferredSize: Size(double.maxFinite, 60),
        child: Container(
          color: Colors.grey.shade900,
          child: Row( 
            children: [
              Gap(20),
                Text(
                "${playlist.songs!.length} Songs",
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              Spacer(),
              Container(
                height: kBottomNavigationBarHeight, alignment: Alignment.center,
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
                    Gap(5),
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
        )
      ),
    );
  }

  SliverPadding _playlistSongs(Playlist playlist) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      sliver: SliverList.builder(
        itemCount: playlist.songs!.length,
        itemBuilder: (context, index) {
          Song song = playlist.songs![index];
          return SongsTile(song);
        },
      ),
    );
  }

  ExpandableFab _floatingActionButton() {
    return ExpandableFab(
      duration: Duration(milliseconds: 250),
      distance: 100.0,
      type: ExpandableFabType.fan,
      pos: ExpandableFabPos.right,
      childrenOffset: Offset(0,0),
      fanAngle: 60,
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
            Get.to(() => ToDoView(text: "Add this playlist to starred"));
          },
          tooltip: "Add to Playlist",
          backgroundColor: accentColorDark, shape: CircleBorder(),
          child: Iconify(MaterialSymbols.star_outline_rounded, color: accentColor, size: 40)
        ),
        FloatingActionButton(
          onPressed: () {
            Get.to(() => ToDoView(text: "Add this playlist to library"));
          },
          tooltip: "Add to Queue",
          backgroundColor: accentColorDark, shape: CircleBorder(),
          child: Iconify(MaterialSymbols.add, color: accentColor, size: 40)
        ),
      ],
    );
  }
}