import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_bottom_sheet_nullsafety/draggable_bottom_sheet_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/views/details/details_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
import 'package:volume_controller/volume_controller.dart';

class MainPlayerView extends StatelessWidget {
  MainPlayerView({super.key});

  final audioManager = getIt<AudioManager>();
  final controller = Get.find<PlayerController>();
  final settings = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Size media = MediaQuery.sizeOf(context);
    return Dismissible(
      key: Key('mainPlayer'),
      direction: DismissDirection.down,
      background: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ColoredBox(color: Colors.transparent),
        ),
      ),
      onDismissed: (_) => Get.back(),
      child: ValueListenableBuilder(
        valueListenable: audioManager.playButtonNotifier,
        builder: (context, state, _) {
          return Obx(() => AnimatedGradientBorder(
            backgroundColor: (theme.brightness == Brightness.light) ? Colors.white : Colors.black,
            borderSize: 5, borderRadius: BorderRadius.zero,
            gradientColors: settings.playerBorderColors[settings.getPlayerBorderIndex],
            isPaused: (state == ButtonState.paused) ? true : false,
            child: BackgroundGradientDecorator(
              child: DraggableBottomSheet(
                backgroundWidget: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Spacer(flex: 1,),
                          _songInfo(context),
                          Gap(20),
                          _artworkAndSlider(media),
                          _durationAndVolume(context),
                          Gap(10),
                          _buttonRows(context),
                          Spacer(flex: 2,),
                        ],
                      ),
                    ),
                  ),
                ),
                minExtent: 70, maxExtent: MediaQuery.of(context).size.height * 0.8,
                previewChild: _bottomChild(context), expandedChild: _bottomSheet(context),
                blurBackground: true, scrollDirection: Axis.vertical, alignment: Alignment.bottomCenter,
              ),
            ),
          ));
        }
      ),
    );
  }

  ValueListenableBuilder _songInfo(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: audioManager.currentSongNotifier,
      builder: (context, song, _) {
        if(song == null) return SizedBox();
        return Column(// * : Song Info
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GlowText(
              song.displayTitle.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, blurRadius: 2,
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: 36, fontWeight: FontWeight.bold
              ),
            ),
            Text(
              song.displaySubtitle.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        );
      }
    );
  }

  Stack _artworkAndSlider(Size media) {
    return Stack(// * : ArtWork & Slider
      alignment: Alignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: audioManager.currentSongNotifier,
          builder: (context, song, _) {
            if(song == null) return SizedBox();
            return ClipOval(// * : Artwork
              child: CachedNetworkImage(
                imageUrl: song.artUri.toString(), fit: BoxFit.cover,
                height: media.width * 0.74, width: media.width * 0.74,
                errorWidget: (_,__,___) {
                  return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.cover, height: media.width * 0.74, width: media.width * 0.74,);
                },
                placeholder: (_,__) {
                  return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.cover, height: media.width * 0.74, width: media.width * 0.74,);
                },
              )
            );
          }
        ),
        ValueListenableBuilder(
          valueListenable: audioManager.progressNotifier,
          builder: (context, state, _) {
            final theme = Theme.of(context);
            double? dragValue;
            bool dragging = false;

            final value = min(state.current.inMilliseconds.toDouble(), state.total.inMilliseconds.toDouble());
            // ignore: dead_code, unnecessary_null_comparison
            if(dragValue != null && dragging) dragValue = null;
            return SizedBox( // * : Slider
              height: media.width * 0.8, width: media.width * 0.8,
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  angleRange: 340,
                  startAngle: 280,
                  customWidths: CustomSliderWidths(
                    handlerSize: 7, progressBarWidth: 8, trackWidth: 4,
                  ),
                  customColors: CustomSliderColors(
                    dotColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
                    progressBarColor: (theme.brightness == Brightness.light) ? Colors.deepPurpleAccent : Colors.purpleAccent,
                    trackColor: (theme.brightness == Brightness.light) ? Colors.blueAccent : Colors.cyanAccent,
                    hideShadow: true,
                    gradientEndAngle: 100,
                    gradientStartAngle: 0
                  ),
                  animationEnabled: false,
                  infoProperties: InfoProperties(mainLabelStyle: TextStyle(color: Colors.transparent)),
                ),
                min: 0, initialValue: value,
                max: max(state.current.inMilliseconds.toDouble(), state.total.inMilliseconds.toDouble()),
                onChangeStart: (startValue) {
                  if(!dragging) return;
                  dragValue = startValue;
                  audioManager.seek(Duration(milliseconds: startValue.round()));
                },
                onChange: (value) => dragValue = value,
                onChangeEnd: (endValue) {
                  audioManager.seek(Duration(milliseconds: endValue.round()));
                  dragging = false;
                },
              ),
            );
          }
        )
      ],
    );
  }

  ValueListenableBuilder _durationAndVolume(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: audioManager.progressNotifier,
      builder: (context, valueState, _) {
        final theme = Theme.of(context);
        return Row( // * : Duration & Volume
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch('${valueState.current}')
                  ?.group(1) ??
                '${valueState.current}',
              style: theme.textTheme.titleSmall,
            ),
            Obx(() => SizedBox(
              width: 225,
              child: InteractiveSlider(
                unfocusedHeight: 20, focusedHeight: 40,
                backgroundColor: (theme.brightness == Brightness.light) 
                    ? Colors.grey.shade300.withOpacity(0.75)
                    : Colors.grey.shade900.withOpacity(0.75),
                foregroundColor: (theme.brightness == Brightness.light) ? Color(0xFF151515) : Color(0xFFFAFAFA),
                iconGap: 8, iconSize: 25, iconPosition: IconPosition.inside,
                startIcon: Iconify(Ion.volume_low, color: Colors.grey,),
                endIcon: Iconify(Ion.volume_high, color: Colors.grey,),
                min: 0, initialProgress: controller.volume.value,  max: 1,
                onChanged: (vol) async {
                  controller.volume.value = vol;
                  VolumeController().setVolume(vol);
                },
                onProgressUpdated: (vol) async {
                  controller.volume.value = vol;
                  VolumeController().setVolume(vol);
                },
                centerIcon: Text('${(controller.volume.value * 100).round()}%', style: TextStyle(color: Colors.grey),),
              ),
            )),
            Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch('${valueState.total}')
                  ?.group(1) ??
                '${valueState.current}',
              style: theme.textTheme.titleSmall,
            ),
          ],
        );
      }
    );
  }

  Column _buttonRows(BuildContext context) {
    final theme = Theme.of(context);
    return Column(// * : Button Rows
      children: [
        Row(// * : Primary Buttons
          children: [
            ValueListenableBuilder(
              valueListenable: audioManager.isShuffleModeEnabledNotifier,
              builder: (context, isShuffle, _) {
                return ValueListenableBuilder(
                  valueListenable: audioManager.playlistNotifier,
                  builder: (context, queue, _) {
                    return IconButton(
                      onPressed: (queue.length > 1) ? audioManager.shuffle : null,
                      padding: EdgeInsets.zero,
                      icon: Iconify(
                        Ri.shuffle_fill,
                        color: (isShuffle)
                            ? (queue.length > 1)
                                ? Colors.grey
                                : null
                            : null,
                        )
                    );
                  }
                );
              }
            ),
            Spacer(flex: 5,),
            ValueListenableBuilder(// * : Previous Song
              valueListenable: audioManager.isFirstSongNotifier,
              builder: (context, isFirst, _) {
                return IconButton(
                  onPressed: (isFirst) ? null : audioManager.previous,
                  padding: EdgeInsets.zero,
                  icon: Iconify(Ic.round_skip_previous, size: 40, color: (isFirst) ? Colors.grey : null,)
                );
              }
            ),
            Spacer(flex: 2,),
            ValueListenableBuilder(// * : Play/Pause Button
              valueListenable: audioManager.playButtonNotifier,
              builder: (context, state, _) {
                return SizedBox.square(
                  dimension: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if(state == ButtonState.loading)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Get.find<SettingsController>().getAccent),
                        ),
                      if(state == ButtonState.playing)
                        IconButton(
                          onPressed: () => audioManager.pause(),
                          padding: EdgeInsets.zero,
                          icon: Iconify(MaterialSymbols.pause_circle, size: 75,),
                        )
                      else
                        IconButton(
                          onPressed: () => audioManager.play(),
                          padding: EdgeInsets.zero,
                          icon: Iconify(MaterialSymbols.play_circle, size: 75,),
                        )
                    ],
                  ),
                );
              }
            ),
            Spacer(flex: 2,),
            ValueListenableBuilder(// * : Next Song
              valueListenable: audioManager.isLastSongNotifier,
              builder: (context, isLast, _) {
                return IconButton(
                  onPressed: (isLast) ? null : audioManager.next,
                  padding: EdgeInsets.zero,
                  icon: Iconify(Ic.round_skip_next, size: 40, color: (isLast) ? Colors.grey : null,)
                );
              }
            ),
            Spacer(flex: 5,),
            ValueListenableBuilder(
              valueListenable: audioManager.repeatButtonNotifier,
              builder: (context, state, _) {
                return ValueListenableBuilder(
                  valueListenable: audioManager.playlistNotifier,
                  builder: (context, queue, _) {
                    if(queue.length < 2) state = RepeatState.repeatSong;
                    return IconButton(
                      onPressed: audioManager.repeat,
                      padding: EdgeInsets.zero,
                      icon: Iconify(
                        (state == RepeatState.repeatSong) ? MaterialSymbols.repeat_one_rounded : MaterialSymbols.repeat_rounded,
                        color: (state == RepeatState.off) ? Colors.grey : null, size: 30,
                      )
                    );
                  }
                );
              }
            ),
          ],
        ),
        Gap(10),
        Row(// * : Secondary Button
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => (controller.currentSong.value.hasLyrics) ? controller.showLyrics(context) : null,
              padding: EdgeInsets.zero,
              icon: Iconify(Ic.twotone_lyrics, size: 27,)
            ),
            Gap(20),
            IconButton(
              onPressed: () => Get.off(() => SongDetailsView(), arguments: controller.currentSong.value.id),
              padding: EdgeInsets.zero,
              icon: Iconify(Entypo.info, size: 27,)
            ),
            Spacer(),
            ClipRRect(// * : Album View
              borderRadius: BorderRadius.circular(12),
              child: ValueListenableBuilder(
                valueListenable: audioManager.currentSongNotifier,
                builder: (context, song, _) {
                  final theme = Theme.of(context);
                  if(song == null) return SizedBox();
                  return InkWell(
                    onTap: () => Get.to(() => AlbumDetailsView(), arguments: controller.album.value.id),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: CachedNetworkImage(
                        imageUrl: controller.album.value.image!.medQuality, fit: BoxFit.cover,
                        height: 50, width: 50,
                        errorWidget: (_,__,___) {
                          return Image.asset("assets/images/albumCover/albumCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                        },
                        placeholder: (_,__) {
                          return Image.asset("assets/images/albumCover/albumCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                        },
                      ),
                    ),
                  );
                }
              ),
            ),
            Spacer(),
            Obx(() => IconButton(
              onPressed: controller.toggleClone,
              padding: EdgeInsets.zero,
              icon: Iconify(
                (controller.isCloned.value) ? Ic.twotone_cyclone : Ic.round_cyclone, size: 30,
                color: (theme.brightness == Brightness.light)
                    ? (controller.isCloned.value) ? Colors.blueAccent: Colors.black
                    : (controller.isCloned.value) ? Colors.cyanAccent: Colors.white
              )
            )),
            Gap(20),
            Obx(() => IconButton(
              onPressed: controller.toggleStarred,
              padding: EdgeInsets.zero,
              icon: Iconify(
                (controller.isStarred.value) ? Uis.favorite : Uit.favorite, size: 30,
                color: (theme.brightness == Brightness.light)
                    ? (controller.isStarred.value) ? Colors.deepOrangeAccent : Colors.black
                    : (controller.isStarred.value) ? Colors.yellowAccent : Colors.white
              )
            )),
          ],
        )
      ],
    );
  }

  Widget _bottomChild(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (theme.brightness == Brightness.light) ? Colors.black12 : Colors.white12,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))
      ),
      child: Row(
        children: [
          Gap(2), Iconify(Ic.round_queue_music, size: 25,),
          Gap(4), Iconify(MaterialSymbols.arrow_right_rounded, size: 25,), Gap(4),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: audioManager.playlistNotifier,
              builder: (context, queue, _) {
                return ListView.builder(
                  itemCount: queue.length, scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    MediaItem media = queue[index];
                    return ValueListenableBuilder(
                      valueListenable: audioManager.currentSongNotifier,
                      builder: (context, currentSong, _) {
                        return GestureDetector(
                          onTap: () {
                            (media.id == audioManager.currentSongNotifier.value!.id) 
                                ? null
                                : audioManager.skipToQueueItem(index);
                          },
                          child: Container(
                            width: 45, height: 45,
                            padding: EdgeInsets.all(2), margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: (currentSong!.id == media.id)
                                  ? Get.find<SettingsController>().getAccent
                                  : Colors.transparent
                              )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: media.artUri.toString(), fit: BoxFit.cover, width: 35, height: 35,
                                errorWidget: (_,__,___) {
                                  return Image.asset(
                                    "assets/images/songCover/songCover50x50.jpg",
                                    fit: BoxFit.cover, width: 35, height: 35
                                  );
                                },
                                placeholder: (_,__) {
                                  return Image.asset(
                                    "assets/images/songCover/songCover50x50.jpg",
                                    fit: BoxFit.cover, width: 35, height: 35
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  },
                );
              },
            ),
          ),
          Gap(10),
          Iconify(MaterialSymbols.swipe_up_rounded, size: 25,), Gap(5)
        ],
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Scaffold(
          backgroundColor: (theme.brightness == Brightness.light)
              ? Colors.grey.shade50.withOpacity(0.5)
              : Colors.grey.shade800.withOpacity(0.5),
          appBar: PreferredSize(
            preferredSize: Size(double.maxFinite, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(8),
                Container(
                  width: 40, height: 5,
                  decoration: BoxDecoration(
                    color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text("Up Next", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          body: ValueListenableBuilder(
            valueListenable: audioManager.playlistNotifier,
            builder: (context, queue, _) {
              final queueStateIndex = (audioManager.currentSongNotifier.value == null)
                  ? 0 : queue.indexOf(audioManager.currentSongNotifier.value!);
              return ReorderableListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: queue.length,
                onReorder: (oldIndex, newIndex) => audioManager.moveMediaItem(oldIndex, newIndex),
                itemBuilder: (context, index) {
                  MediaItem media = queue[index];
                  return Dismissible(
                    key: Key(media.id),
                    direction: (index == queueStateIndex) ? DismissDirection.none : DismissDirection.horizontal,
                    onDismissed: (_) => audioManager.removeQueueItemAt(index),
                    child: MediaItemTile(media, index: index, queueStateIndex: queueStateIndex),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}