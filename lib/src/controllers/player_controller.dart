import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:super_string/super_string.dart';

class PlayerController extends GetxController {
  final audioManager = getIt<AudioManager>();
  final starDb = getIt<StarredDatabase>();
  final cloneDb = getIt<ClonedDatabase>();

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
    isStarred.value = await starDb.isPresent(currentSong.value);
    isCloned.value = await cloneDb.isPresent(currentSong.value);
    update();
  }

  Future<void> setSong() async {
    MediaItem? currentMediaItem = audioManager.currentSongNotifier.value;
    if(currentMediaItem != null) {
      currentSong.value = Song.fromMediaItem(currentMediaItem);
      lyrics.value = await LyricsApi.fetch(currentSong.value);
      await checkCloneAndStar();
      getAlbum();
      update();
    }
  }

  void toggleStarred() async {
    if(!isStarred.value) await starDb.starred(currentSong.value);
    else await starDb.deleteStarred(currentSong.value);
    await checkCloneAndStar();
  }

  void toggleClone() async {
    if(!isCloned.value) await cloneDb.clone(currentSong.value);
    else await cloneDb.deleteClone(currentSong.value);
    await checkCloneAndStar();
  }

  void showLyrics(BuildContext context) {
    final theme = Theme.of(context);
    showFlexibleBottomSheet(
      minHeight: 0, initHeight: 0.5, maxHeight: 0.8,
      isSafeArea: true, bottomSheetColor: Colors.transparent,
      bottomSheetBorderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      isCollapsible: true, isDismissible: true,
      context: context, builder: (_, __, ___) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(10),
              Text(
                lyrics.value.snippet.title(), maxLines: 1, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center, style: theme.textTheme.titleLarge,
              ),
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        backgroundColor: Colors.grey.shade800,
                        title: "© Copyright",
                        titleStyle: theme.textTheme.headlineMedium!.copyWith(color: Colors.cyan),
                        content: SelectableText(
                          lyrics.value.copyright, textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium
                        )
                      );
                    },
                    icon: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(child: Iconify(Ic.twotone_copyright, color: Colors.cyan, size: 16)),
                          TextSpan(
                            text: " Copyright",
                            style: theme.textTheme.labelSmall!.copyWith(color: Colors.cyan)
                          )
                        ]
                      ),
                    )
                  ),
                  Gap(20)
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SelectableText.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: lyrics.value.lyrics.replaceAll('<br>', '\n').title(),
                            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  
  void getAlbum() async => album.value = await AlbumDetailsApi.getImage(currentSong.value.album!.id);
}
