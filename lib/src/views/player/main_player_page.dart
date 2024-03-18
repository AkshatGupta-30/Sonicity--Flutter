// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:gap/gap.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/entypo.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:iconify_flutter_plus/icons/uit.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:sonicity/src/controllers/song_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';
// TODO - Adjust View with theme (Dark , light)
class MainPlayerView extends StatelessWidget {
  final Song song;
  final SongController controller;
  MainPlayerView({super.key, required this.song, required this.controller});

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {},
      child: AnimatedGradientBorder(
        backgroundColor: Colors.black,
        borderSize: 10, borderRadius: BorderRadius.zero,
        gradientColors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
        child: BackgroundGradientDecorator(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: Icon(Icons.keyboard_arrow_down),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Column(// * : Song Info
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GlowText(
                          song.title, maxLines: 1, overflow: TextOverflow.ellipsis, blurRadius: 2,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 45, fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                        ),
                      ],
                    ),
                    Gap(20),
                    Stack(// * : ArtWork & Slider
                      alignment: Alignment.center,
                      children: [
                        Hero(// * : ArtWork
                          tag: "currentArtwork",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(media.width * 0.8),
                            child: CachedNetworkImage(
                              imageUrl: song.image.highQuality, fit: BoxFit.cover,
                              height: media.width * 0.75, width: media.width * 0.75,
                              errorWidget: (context, url, error) {
                                return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.cover, height: media.width * 0.75, width: double.maxFinite,);
                              },
                              placeholder: (context, url) {
                                return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.cover, height: media.width * 0.75, width: double.maxFinite,);
                              },
                            )
                          ),
                        ),
                        Container( // * : Slider
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
                            min: 0,
                            max: double.parse(song.duration.toString()), // TODO
                            initialValue: 20, // TODO
                            onChangeStart: (startValue) {}, // TODO
                            onChangeEnd: (endValue) {}, // TODO
                          ),
                        )
                      ],
                    ),
                    Gap(10),
                    Row( // * : Duration & Volume
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('00:00', style: Theme.of(context).primaryTextTheme.headlineSmall,),// TODO : Song current duration
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
                        Text('03:20', style: Theme.of(context).primaryTextTheme.headlineSmall,), // TODO : Song total duration
                      ],
                    ),
                    Gap(10),
                    Column(// * : Button Rows
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
                            Icon(Icons.repeat_one_rounded, size: 30, color: Colors.grey,), // TODO - MaterialSymbols.repeat_rounded
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
                    ),
                    Spacer(),
                    Container(// * : Album View
                      width: double.maxFinite, height: 60, alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container( // TODO - Open Album
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: CachedNetworkImage(
                            imageUrl: song.image.medQuality, fit: BoxFit.cover,
                            height: 50, width: 50,
                            errorWidget: (context, url, error) {
                              return Image.asset("assets/images/albumCover/albumCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                            },
                            placeholder: (context, url) {
                              return Image.asset("assets/images/albumCover/albumCover150x150.jpg", fit: BoxFit.cover, height: 50, width: 50,);
                            },
                          ),
                        ),
                      ),
                    ),
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
}