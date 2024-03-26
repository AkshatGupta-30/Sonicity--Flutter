import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/views/details/details_view.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
// TODO - Adjust View with theme (Dark , light)
class MainPlayerView extends StatelessWidget {
  MainPlayerView({super.key});

  final audioManager = getIt<AudioManager>();
  final controller = Get.find<PlayerController>();
  @override
  Widget build(BuildContext context) {
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
      onDismissed: (direction) => Get.back(),
      child: ValueListenableBuilder(
        valueListenable: audioManager.playButtonNotifier,
        builder: (context, state, _) {
          return AnimatedGradientBorder( // TODO - Various Options of Main screen view
            backgroundColor: Colors.black,
            borderSize: 10, borderRadius: BorderRadius.zero,
            gradientColors: [
              Colors.red, Colors.orange, Colors.yellow,
              Colors.lightGreen, Colors.green, Colors.cyan,
              Colors.blue, Colors.purple, Colors.pink
            ],
            isPaused: (state == ButtonState.paused) ? true : false,
            child: BackgroundGradientDecorator(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Spacer(flex: 2,),
                        _songInfo(context),
                        Spacer(flex: 2,),
                        _artworkAndSlider(media),
                        Spacer(flex: 1,),
                        _durationAndVolume(context),
                        Spacer(flex: 1,),
                        _buttonRows(context),
                        Spacer(flex: 2,),
                        _albumViewAndEqualizer(),
                        Spacer(flex: 1,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  ValueListenableBuilder _songInfo(BuildContext context) {
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
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 45, fontWeight: FontWeight.bold
              ),
            ),
            Text(
              song.displaySubtitle.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).primaryTextTheme.titleLarge,
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
                height: media.width * 0.75, width: media.width * 0.75,
                errorWidget: (context, url, error) {
                  return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.cover, height: media.width * 0.75, width: media.width * 0.75,);
                },
                placeholder: (context, url) {
                  return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.cover, height: media.width * 0.75, width: media.width * 0.75,);
                },
              )
            );
          }
        ),
        ValueListenableBuilder(
          valueListenable: audioManager.progressNotifier,
          builder: (context, valueState, _) {
            double? dragValue;
            bool dragging = false;

            final value = min(valueState.current.inMilliseconds.toDouble(), valueState.total.inMilliseconds.toDouble());
            // ignore: dead_code, unnecessary_null_comparison
            if(dragValue != null && dragging) dragValue = null;
            return Container( // * : Slider
              height: media.width * 0.8, width: media.width * 0.8,
              margin: EdgeInsets.symmetric( vertical: 10),
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  angleRange: 340,
                  startAngle: 280,
                  customWidths: CustomSliderWidths(
                    handlerSize: 8, progressBarWidth: 8, trackWidth: 4,
                  ),
                  customColors: CustomSliderColors(
                    dotColor: Colors.white,
                    progressBarColor: Colors.purpleAccent,
                    trackColor: Colors.cyanAccent,
                    hideShadow: true,
                    gradientEndAngle: 100,
                    gradientStartAngle: 0
                  ),
                  animationEnabled: false,
                  infoProperties: InfoProperties(mainLabelStyle: TextStyle(color: Colors.transparent)),
                ),
                min: 0, initialValue: value,
                max: max(valueState.current.inMilliseconds.toDouble(), valueState.total.inMilliseconds.toDouble()),
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
              style: Theme.of(context).primaryTextTheme.headlineSmall,
            ),
            Obx(() => SizedBox(
              width: 225,
              child: InteractiveSlider( // TODO - Volume Control
                unfocusedHeight: 20, focusedHeight: 40,
                backgroundColor: Colors.grey.shade900.withOpacity(0.75),
                foregroundColor: Colors.grey.shade50,
                iconGap: 8, iconSize: 25, iconPosition: IconPosition.inside,
                startIcon: Iconify(Ion.volume_low, color: Colors.grey,),
                endIcon: Iconify(Ion.volume_high, color: Colors.grey,),
                min: 0, initialProgress: controller.volume.value,  max: 1,
                onChanged: (vol) async {
                  controller.volume.value = vol;
                  await PerfectVolumeControl.setVolume(vol);
                },
                onProgressUpdated: (vol) async {
                  controller.volume.value = vol;
                  await PerfectVolumeControl.setVolume(vol);
                },
                centerIcon: Text('${(controller.volume.value * 100).round()}%', style: TextStyle(color: Colors.grey),),
              ),
            )),
            Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch('${valueState.total}')
                  ?.group(1) ??
                '${valueState.current}',
              style: Theme.of(context).primaryTextTheme.headlineSmall,
            ),
          ],
        );
      }
    );
  }

  Column _buttonRows(BuildContext context) {
    return Column(// * : Button Rows
      children: [
        Row(// * : Primary Buttons
          children: [
            ValueListenableBuilder(
              valueListenable: audioManager.isShuffleModeEnabledNotifier,
              builder: (context, isShuffle, _) {
                return IconButton(
                  onPressed: audioManager.shuffle,
                  padding: EdgeInsets.zero,
                  icon: Iconify(Ri.shuffle_fill, color: (isShuffle) ? null : Colors.grey,)
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
                return IconButton(
                  onPressed: audioManager.repeat,
                  padding: EdgeInsets.zero,
                  icon: Iconify(
                    (state == RepeatState.repeatSong) ? MaterialSymbols.repeat_one_rounded : MaterialSymbols.repeat_rounded,
                    color: (state == RepeatState.off) ? Colors.grey : null, size: 30,
                  )
                );
              }
            ),
          ],
        ),
        Gap(15),
        Row(// * : Secondary Button
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
            Obx(() => IconButton(
              onPressed: controller.toggleClone,
              padding: EdgeInsets.zero,
              icon: Iconify(
                (controller.isCloned.value) ? Ic.twotone_cyclone : Ic.round_cyclone, size: 30,
                color: (controller.isCloned.value) ? Colors.cyanAccent: Colors.white
              )
            )),
            Gap(20),
            Obx(() => IconButton(
              onPressed: controller.toggleStarred,
              padding: EdgeInsets.zero,
              icon: Iconify(
                (controller.isStarred.value) ? Uis.favorite : Uit.favorite, size: 30,
                color: (controller.isStarred.value) ? Colors.yellowAccent : Colors.white
              )
            )),
          ],
        )
      ],
    );
  }

  Row _albumViewAndEqualizer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(// * : Album View
          borderRadius: BorderRadius.circular(12),
          child: ValueListenableBuilder(
            valueListenable: audioManager.currentSongNotifier,
            builder: (context, song, _) {
              if(song == null) return SizedBox();
              return InkWell(
                onTap: () => Get.to(() => AlbumDetailsView(), arguments: song.album),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: CachedNetworkImage(
                    imageUrl: song.artUri.toString(), fit: BoxFit.cover,
                    height: 50, width: 50,
                    errorWidget: (context, url, error) {
                      return Image.asset("assets/images/albumCover/albumCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                    },
                    placeholder: (context, url) {
                      return Image.asset("assets/images/albumCover/albumCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                    },
                  ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}