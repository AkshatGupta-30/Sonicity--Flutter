import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:super_string/super_string.dart';

class PlayerController extends GetxController {
  final audioManager = getIt<AudioManager>();

  final volume = 0.0.obs;

  final isStarred = false.obs;
  final isCloned = false.obs;
  final currentSong = Song.empty().obs;
  final album = Album.empty().obs;
  final lyrics = Lyrics.empty().obs;

  @override
  void onInit() {
    super.onInit();
    setSong();
    audioManager.currentSongNotifier.addListener(() async {
      await setSong();
      await checkCloneAndStar();
    });
    volumeConfig();
  }

  void volumeConfig() async {
    volume.value = await PerfectVolumeControl.getVolume();
    PerfectVolumeControl.stream.listen((vol) => volume.value = vol);
  }

  Future<void> checkCloneAndStar() async {
    isStarred.value = await getIt<StarredDatabase>().isPresent(currentSong.value);
    isCloned.value = await getIt<ClonedDatabase>().isPresent(currentSong.value);
    update();
  }

  Future<void> setSong() async {
    MediaItem? currentMediaItem = audioManager.currentSongNotifier.value;
    if(currentMediaItem != null) {
      currentSong.value = Song.fromMediaItem(currentMediaItem);
      lyrics.value = await LyricsApi.fetch(currentSong.value);
      await checkCloneAndStar();
      getIt<RecentsDatabase>().insertSong(currentSong.value);
      getAlbum();
      update();
    }
  }

  void toggleStarred() async {
    if(!isStarred.value) await getIt<StarredDatabase>().starred(currentSong.value);
    else await getIt<StarredDatabase>().deleteStarred(currentSong.value);
    await checkCloneAndStar();
  }

  void toggleClone() async {
    if(!isCloned.value) await getIt<ClonedDatabase>().clone(currentSong.value);
    else await getIt<ClonedDatabase>().deleteClone(currentSong.value);
    await checkCloneAndStar();
  }

  void showLyrics(BuildContext context) {
    showFlexibleBottomSheet(
      minHeight: 0, initHeight: 0.5, maxHeight: 0.8,
      isSafeArea: true, bottomSheetColor: Colors.transparent,
      bottomSheetBorderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      isCollapsible: true, isDismissible: true,
      context: context, builder: (context, scrollController, bottomSheetOffset) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Obx(() {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                lyrics.value.snippet.title(), maxLines: 1, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge,
              ),
              bottom: PreferredSize(
                preferredSize: Size(double.maxFinite, 16),
                child: Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          backgroundColor: Colors.grey.shade800,
                          title: "© Copyright",
                          titleStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.cyan),
                          content: SelectableText(
                            lyrics.value.copyright, textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                          )
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <InlineSpan>[
                            WidgetSpan(child: Iconify(Ic.twotone_copyright, color: Colors.cyan, size: 16)),
                            TextSpan(
                              text: " Copyright",
                              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.cyan)
                            )
                          ]
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 21),
              children: [
                SelectableText.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: lyrics.value.lyrics.replaceAll('<br>', '\n').title(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
  
  void getAlbum() async => album.value = await AlbumDetailsApi.getImage(currentSong.value.album!.id);
}
