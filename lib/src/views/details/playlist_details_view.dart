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
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class PlaylistDetailsView extends StatelessWidget {
  PlaylistDetailsView({super.key});

  final controller = Get.find<PlaylistDetailController>();
  
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if(didPop) {
          Get.delete<PlaylistDetailController>();
        }
      },
      child: Scaffold(
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
          child: Obx(
            () {
              Playlist playlist = controller.playlist.value;
              if(playlist.isEmpty()) {
                return Center(
                  child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true, floating: false, snap: false,
                    toolbarHeight: kBottomNavigationBarHeight,
                    shadowColor: Colors.black87, surfaceTintColor: Colors.black87, backgroundColor: Colors.grey.shade900,
                    leading: BackButton(color: Colors.white),
                    expandedHeight: 360,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true, expandedTitleScale: 1.5,
                      stretchModes: [StretchMode.blurBackground],
                      titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      title: SizedBox(
                        width: media.width/1.4, height: kBottomNavigationBarHeight,
                        child: Text(
                          playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      background: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: playlist.image.highQuality, fit: BoxFit.fill,
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
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              onTap: () {
                                Get.to(() => ToDoView(text: "Sorting of songs"));
                              },
                              child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
                            ),
                            PopupMenuItem(
                              child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
                            ),
                            PopupMenuItem(
                              child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Duration Asc")
                            ),
                            PopupMenuItem(
                              child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Duration Desc")
                            ),
                            PopupMenuItem(
                              child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Year Asc")
                            ),
                            PopupMenuItem(
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
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    sliver: SliverList.builder(
                      itemCount: playlist.songs!.length,
                      itemBuilder: (context, index) {
                        Song song = playlist.songs![index];
                        return SongsRow(song: song);
                      },
                    ),
                  ),
                ],
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
                Get.to(() => ToDoView(text: "Add this playlist to starred"));
              },
              tooltip: "Add to Playlist",
              backgroundColor: accentColorDark, shape: CircleBorder(),
              child: Iconify(MaterialSymbols.star_outline_rounded, color: accentColor, size: 40)
            ),
            FloatingActionButton(
              onPressed: () {
                Get.to(() => ToDoView(text: "Play all songs"));
              },
              tooltip: "Play Now",
              backgroundColor: accentColorDark, shape: CircleBorder(),
              child: Iconify(Ic.twotone_play_circle, color: accentColor, size: 40)
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
        ),
      ),
    );
  }
}