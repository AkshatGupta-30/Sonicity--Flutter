// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ant_design.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/song_detail_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';

class SongInfoView extends StatelessWidget {
  SongInfoView({super.key});

  final controller = Get.find<SongDetailController>();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    EdgeInsets safeArea = MediaQuery.paddingOf(context);
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
        child: Obx(
          () {
            Song song = controller.song.value;
            if(song.isEmpty()) {
              return Center(
                child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true, floating: false, snap: false,
                  toolbarHeight: kBottomNavigationBarHeight,
                  backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent,
                  leading: BackButton(color: Colors.white),
                  expandedHeight: 400,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true, expandedTitleScale: 1.5,
                    stretchModes: [StretchMode.blurBackground],
                    titlePadding: EdgeInsets.only(left: 10, top: safeArea.top, right: 10, bottom: 5),
                    title: Text(
                      song.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _divide(),
                        _head("Name"),
                        _detail(song.name),
                        _divide(),
                        _head("From Album"),
                        _divide(),
                        _head("Contributed Artists"),
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
                        _head("Download url"),
                        _divide(),
                      ],
                    ),
                  ),
                )
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
            onPressed: () {},
            tooltip: "Add to Playlist",
            backgroundColor: accentColorDark, shape: CircleBorder(),
            child: Iconify(Tabler.playlist_add, color: accentColor, size: 40)
          ),
          FloatingActionButton(
            onPressed: () {},
            tooltip: "Play Now",
            backgroundColor: accentColorDark, shape: CircleBorder(),
            child: Iconify(Ic.twotone_play_arrow, color: accentColor, size: 40)
          ),
          FloatingActionButton(
            onPressed: () {},
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
}