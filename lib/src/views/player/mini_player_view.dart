import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/views/player/main_player_view.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class MiniPlayerView extends StatelessWidget {
  static final MiniPlayerView _instance = MiniPlayerView._internal();
  factory MiniPlayerView() => _instance;
  MiniPlayerView._internal();

  final controller = Get.find<PlayerController>();
  @override
  Widget build(BuildContext context) {
    final audioManager = getIt<AudioManager>();
    return ValueListenableBuilder<AudioProcessingState>(
      valueListenable: audioManager.playbackStatNotifier,
      builder: (context, processingState, _) {
        if(processingState == AudioProcessingState.idle) return SizedBox();
        return ValueListenableBuilder<MediaItem?>(
          valueListenable: audioManager.currentSongNotifier,
          builder: (context, mediaItem, _) {
            if(mediaItem == null) return SizedBox();
            return Dismissible(
              key: const Key("mini_player"),
              direction: DismissDirection.down,
              onDismissed: (direction) {
                Feedback.forLongPress(context);
                audioManager.stop();
              },
              child: Dismissible(
                key: Key(mediaItem.id),
                confirmDismiss: (direction) {
                  if(direction == DismissDirection.startToEnd) audioManager.previous();
                  else audioManager.next();
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
                              ValueListenableBuilder<ProgressBarState>(
                                valueListenable: audioManager.progressNotifier,
                                builder: (context, value, _) {
                                  final position = value.current;
                                  final total = value.total;
                                  if(position.inSeconds.toDouble() < 0.0 || position.inSeconds.toDouble() > total.inSeconds.toDouble()) return SizedBox();
                                  return SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Get.find<SettingsController>().getAccent,
                                      inactiveTrackColor: Colors.grey, trackHeight: 5,
                                      thumbColor: Get.find<SettingsController>().getAccent,
                                      thumbShape:  RoundSliderOverlayShape(overlayRadius: 2.5),
                                      overlayColor: Colors.transparent, overlayShape: RoundSliderOverlayShape(overlayRadius: 2.5)
                                    ),
                                    child: Center(
                                      child: Slider(
                                        min: 0,
                                        value: position.inSeconds.toDouble(),
                                        max: total.inSeconds.toDouble(),
                                        onChanged: (newPosition) => audioManager.seek(Duration(seconds: newPosition.round())),
                                        inactiveColor: Colors.transparent,
                                      ),
                                    ),
                                  );
                                }
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_,__,___) => MainPlayerView(),
                                    )
                                  );
                                },
                                leading: ClipRRect(// * : Song Artwork
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: mediaItem.artUri.toString(), fit: BoxFit.cover,
                                    height: 50, width: 50,
                                    errorWidget: (context, url, error) {
                                      return Image.asset("assets/images/songCover/songCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                                    },
                                    placeholder: (context, url) {
                                      return Image.asset("assets/images/songCover/songCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                                    },
                                  )
                                ),
                                title: Text(
                                  mediaItem.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                subtitle: Text(
                                  mediaItem.displaySubtitle ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() => IconButton(
                                      onPressed: controller.toggleStarred,
                                      padding: EdgeInsets.zero,
                                      icon: Iconify(
                                        (controller.isFavorite.value) ? Uis.favorite : Uit.favorite, size: 30,
                                        color: (controller.isFavorite.value) ? Colors.yellowAccent : Colors.white
                                      )
                                    )),
                                    Gap(5),
                                    ValueListenableBuilder<ButtonState>(
                                      valueListenable: audioManager.playButtonNotifier,
                                      builder: (context, state, _) {
                                        if(state == ButtonState.loading) {
                                          return CircularProgressIndicator(color: Get.find<SettingsController>().getAccent);
                                        } else {
                                          return IconButton(
                                            onPressed: (state == ButtonState.playing) ? audioManager.pause : audioManager.play,
                                            padding: EdgeInsets.zero,
                                            icon: Iconify((state == ButtonState.playing) ? Ic.round_pause : Ic.round_play_arrow, size: 36,)
                                          );
                                        }
                                      }
                                    ),
                                    Gap(5),
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
        );
      }
    );
  }
}