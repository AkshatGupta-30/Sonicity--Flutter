// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/views/details/album_details_view.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
// TODO - Adjust View with theme (Dark , light)
class MainPlayerView extends StatelessWidget {
  MainPlayerView({super.key});

  final audioManager = getIt<AudioManager>();
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
      child: AnimatedGradientBorder( // TODO - Various Options of Main screen view
        backgroundColor: Colors.black,
        borderSize: 10, borderRadius: BorderRadius.zero,
        gradientColors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
        child: BackgroundGradientDecorator(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _songInfo(context),
                    Gap(20),
                    _artworkAndSlider(media),
                    Gap(10),
                    _durationAndVolume(context),
                    Gap(10),
                    _buttonRows(),
                    Spacer(),
                    _albumViewAndEqualizer(),
                    Gap(10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _songInfo(BuildContext context) {
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
            return Hero(// * : ArtWork
              tag: "currentArtwork",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(media.width * 0.8),
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
              ),
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

  _durationAndVolume(BuildContext context) {
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
            SizedBox(
              width: 225,
              child: InteractiveSlider( // TODO - Volume Control
                unfocusedHeight: 20, focusedHeight: 40,
                backgroundColor: Colors.grey.shade900.withOpacity(0.75),
                foregroundColor: Colors.grey.shade50,
                iconGap: 8, iconSize: 25, iconPosition: IconPosition.inside,
                startIcon: Iconify(Ion.volume_low, color: Colors.grey,),
                endIcon: Iconify(Ion.volume_high, color: Colors.grey,),
                min: 0, max: 100,
                onChanged: (value) {},
                onProgressUpdated: (value) {},
              ),
            ),
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

  Column _buttonRows() {
    return Column(// * : Button Rows
      children: [
        Row(// * : Primary Buttons
          children: [
            Iconify(Uit.favorite, size: 30,), // TODO - Star
            Spacer(flex: 2,),
            Iconify(Ic.round_skip_previous, size: 35,), // TODO - Previous Song
            Spacer(flex: 2,),
            Iconify(MaterialSymbols.pause_circle, size: 75,), // TODO - MaterialSymbols.play_circle
            Spacer(flex: 2,),
            Iconify(Ic.round_skip_next, size: 35,), // TODO - Next Song
            Spacer(flex: 2,),
            Iconify(MaterialSymbols.repeat_rounded, size: 30, color: Colors.grey,), // TODO - (Repeat) MaterialSymbols.repeat_rounded, Icons.repeat_one_rounded
          ],
        ),
        Gap(15),
        Row(// * : Secondary Button
          children: [
            Iconify(Ic.twotone_lyrics, size: 27,), // TODO - Lyrics
            Gap(20),
            Iconify(Entypo.info, size: 27,), // TODO - Song Info
            Spacer(),
            Iconify(Bi.speaker_fill, size: 27,), // TODO - System Sound = Ion.headset, Mdi.cellphone_sound, Bi.speaker_fill
            Gap(20),
            Iconify(Ri.shuffle_fill), // TODO - Shuffle
          ],
        )
      ],
    );
  }

  Row _albumViewAndEqualizer() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
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
        Spacer(),
        Iconify(Mdi.equalizer, size: 40,), // TODO - Equalizer - 'equalizer_flutter_custom'
      ],
    );
  }
}