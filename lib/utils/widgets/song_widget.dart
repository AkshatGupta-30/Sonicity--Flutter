import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/details/details_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class SongCard extends StatelessWidget {
  final Song song;
  SongCard(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var media = MediaQuery.sizeOf(context);
    return GetBuilder(
      global: false,
      init: SongController(song),
      builder: (controller) {
        return GestureDetector(
          onTap: () async => playSong(song, isAutoQueue: true),
          child: Container(
            width: media.width/1.25, height: media.width/1.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: song.image.highQuality,
                    width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                    placeholder: (_,__) {
                      return Image.asset(
                        "assets/images/songCover/songCover500x500.jpg",
                        width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                      );
                    },
                    errorWidget: (_,__,___) {
                      return Image.asset(
                        "assets/images/songCover/songCover500x500.jpg",
                        width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: media.width/1.25, height: media.width/1.25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (theme.brightness == Brightness.light)
                          ? [Colors.white.withOpacity(0.25), Colors.grey.shade200]
                          : [Colors.black.withOpacity(0.25), Colors.black],
                        begin: Alignment.center, end: Alignment.bottomCenter,
                        stops: [0.4, 1]
                      )
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Text>[
                      Text(
                        song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge!,
                      ),
                      Text(
                        song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: (theme.brightness == Brightness.light) ? Colors.grey.shade800 : null
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0, right: 0,
                  child: SongPopUpMenu(song, controller: controller),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class SongTile extends StatelessWidget {
  final Song song;
  final String subtitle;
  SongTile(this.song, {super.key, this.subtitle = ""});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: SongController(song),
      builder: (controller) => ListTile(
        onTap: () async => playSong(song, isAutoQueue: true),
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: song.image.lowQuality, fit: BoxFit.cover, width: 50, height: 50,
            errorWidget: (_,__,___) {
              return Image.asset(
                "assets/images/songCover/songCover50x50.jpg",
                fit: BoxFit.cover, width: 50, height: 50
              );
            },
            placeholder: (_,__) {
              return Image.asset(
                "assets/images/songCover/songCover50x50.jpg",
                fit: BoxFit.cover, width: 50, height: 50
              );
            },
          ),
        ),
        horizontalTitleGap: 10,
        title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
        subtitle: Text((subtitle.isEmpty) ? song.subtitle : subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,),
        trailing:  SongPopUpMenu(song, controller: controller)
      )
    );
  }
}

class SongCell extends StatelessWidget {
  final Song song;
  final String subtitle;
  SongCell(this.song, {super.key, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async => playSong(song, isAutoQueue: true),
      child: Container(
        width: 140,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: song.image.medQuality,
                width: 140, height: 140, fit: BoxFit.fill,
                placeholder: (_,__) {
                  return Image.asset(
                    "assets/images/albumCover/albumCover150x150.jpg",
                    width: 140, height: 140, fit: BoxFit.fill,
                  );
                },
                errorWidget: (_,__,___) {
                  return Image.asset(
                    "assets/images/albumCover/albumCover150x150.jpg",
                    width: 140, height: 140, fit: BoxFit.fill,
                  );
                },
              ),
            ),
            Gap(2),
            Text(
              song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge!.copyWith(fontSize: 14),
            ),
            Text(
              (subtitle.isEmpty) ? song.subtitle : subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}

class MediaItemTile extends StatelessWidget {
  final MediaItem song;
  final int index, queueStateIndex;
  MediaItemTile(this.song, {super.key, required this.index, required this.queueStateIndex});

  final audioManager = getIt<AudioManager>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: audioManager.currentSongNotifier,
      builder: (context, mediaItem, _) {
        return ListTile(
          onTap: () => (mediaItem.id == song.id) ? null : audioManager.skipToQueueItem(index),
          tileColor: (mediaItem!.id != song.id) 
              ? null
              : (theme.brightness == Brightness.light)
                  ? Color.fromRGBO(0, 0, 0, 0.30)
                  : Colors.white12,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: song.artUri.toString(), fit: BoxFit.cover, width: 50, height: 50,
              errorWidget: (_,__,___) {
                return Image.asset(
                  "assets/images/songCover/songCover50x50.jpg",
                  fit: BoxFit.cover, width: 50, height: 50
                );
              },
              placeholder: (_,__) {
                return Image.asset(
                  "assets/images/songCover/songCover50x50.jpg",
                  fit: BoxFit.cover, width: 50, height: 50
                );
              },
            ),
          ),
          horizontalTitleGap: 10,
          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
          subtitle: Text(song.displaySubtitle.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,),
          trailing: (index == queueStateIndex)
              ? ValueListenableBuilder(
                valueListenable: audioManager.playButtonNotifier,
                builder: (context, state , _) {
                  return Lottie.asset(
                    'assets/lottie/speaker.json', animate: (state == ButtonState.playing),
                    fit: BoxFit.cover,
                  );
                }
              )
              : ReorderableDragStartListener(
                key: Key(song.id),
                index: index,
                enabled: index != queueStateIndex,
                child: Iconify(Ion.reorder_two, size: 30,),
              ),
        );
      }
    );
  }
}

class SongPopUpMenu extends StatelessWidget {
  final Song song;
  final SongController controller;
  SongPopUpMenu(this.song, {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton(
      onOpened: () => controller.checkCloneAndStar(),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => controller.switchCloned(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() => PopUpButtonRow(
              icon: (controller.isClone.value) ? Ic.twotone_cyclone : Ic.round_cyclone,
              label: (controller.isClone.value) ? "Remove from Library" : "Clone to Library"
            )),
          ),
          PopupMenuItem(
            onTap: () => controller.switchStarred(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() => PopUpButtonRow(
              icon: (controller.isStar.value) ? Mi.favorite : Uis.favorite,
              label: (controller.isStar.value) ? "Remove from Star" : "Add to Starred"
            )),
          ),
          PopupMenuItem(
            onTap: () => _addToQueueDialog(context),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: MaterialSymbols.queue_music, label: "Add to Queue"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            onTap: () => _addToPlaylistDialog(context),
            child: PopUpButtonRow(icon: Tabler.playlist_add, label: "Add to Playlist"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            onTap: () => Get.to(() => AlbumDetailsView(), arguments: song.album!.id),
            child: PopUpButtonRow(icon: MaterialSymbols.album, label: "View Album"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            onTap: () => Get.to(() => SongDetailsView(), arguments: song.id),
            child: PopUpButtonRow(icon: Entypo.info_with_circle, label: "Song Info"),
          )
        ];
      },
      padding: EdgeInsets.zero,
      icon: Iconify(
        Ic.sharp_more_vert, size: 32,
        color: (theme.brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      ),
    );
  }

  void _addToPlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent,
          child: AddToPlaylistDialog(song),
        );
      }
    );
  }

  void _addToQueueDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, shadowColor: Colors.transparent,
          alignment: Alignment.center,
          child: AddToQueueDialog(song),
        );
      }
    );
  }
}