import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/uit.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/controllers/song_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/iconify.dart';

class MiniPlayerView extends StatelessWidget {
  final SongController controller;
  final Song song;
  MiniPlayerView({super.key, required this.song, required this.controller});// TODO - Singleton constructor

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("mini_player"),
      direction: DismissDirection.down,
      onDismissed: (direction) => Feedback.forLongPress(context),
      child: Dismissible(
        key: Key(song.id),
        confirmDismiss: (direction) {
          if(direction == DismissDirection.startToEnd) {
            // TODO - Previous Song
          } else {
            // TODO - Next Song
          }
          return Future.value(false);
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.white10,
          child: SizedBox(
            height: 80,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.black, Colors.transparent]
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dst,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SliderTheme(// TODO - Silder Duration
                        data: SliderThemeData(
                          activeTrackColor: Get.find<SettingsController>().getAccent,
                          inactiveTrackColor: Colors.grey, trackHeight: 5,
                          thumbColor: Get.find<SettingsController>().getAccent,
                          thumbShape:  RoundSliderOverlayShape(overlayRadius: 2.5),
                          overlayColor: Colors.transparent, overlayShape: RoundSliderOverlayShape(overlayRadius: 2.5)
                        ),
                        child: Center(
                          child: Slider(
                            value: 25,
                            onChanged: (newPosition) {},
                            max: 100,
                            inactiveColor: Colors.transparent,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {}, // TODO - Open Main Player View
                        leading: ClipRRect(// * : Song Artwork
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: song.image.medQuality, fit: BoxFit.cover,
                            height: 50, width: 50,
                            errorWidget: (context, url, error) {
                              return Image.asset("assets/images/songCover/songCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                            },
                            placeholder: (context, url) {
                              return Image.asset("assets/images/songCover/songCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                            },
                          )
                        ),
                        title: Text(// TODO - Title
                          'song.title', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(// TODO - Subtitle
                          'song.subtitle', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Iconify(Ic.round_pause, size: 36,), // TODO - Play/Pause (Ic.round_pause, Ic.round_play_arrow)
                            Gap(5),
                            Iconify(Uit.favorite, size: 27,), // TODO - Star (Uis.favorite, Uit.favorite)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}