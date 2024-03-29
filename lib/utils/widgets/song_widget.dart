import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/details/details_view.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

//TODO add Hero widget

class SongCard extends StatelessWidget {
  final Song song;
  SongCard(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return GetBuilder(
      global: false,
      init: SongController(song),
      builder: (controller) {
        return GestureDetector(
          onTap: () async {
            playSong(song);
            RecentsDatabase recents = getIt<RecentsDatabase>();
            await recents.insertSong(song);
          },
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
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/songCover/songCover500x500.jpg",
                        width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                      );
                    },
                    errorWidget: (context, url, error) {
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
                        colors: (Theme.of(context).brightness == Brightness.light)
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
                        style: Theme.of(context).textTheme.labelLarge!,
                      ),
                      Text(
                        song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade800 : null
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
        onTap: () async {
          playSong(song);
          RecentsDatabase recents = getIt<RecentsDatabase>();
          await recents.insertSong(song);
        },
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: song.image.lowQuality, fit: BoxFit.cover, width: 50, height: 50,
            errorWidget: (context, url, error) {
              return Image.asset(
                "assets/images/songCover/songCover50x50.jpg",
                fit: BoxFit.cover, width: 50, height: 50
              );
            },
            placeholder: (context, url) {
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
    return GestureDetector(
      onTap: () async {
        playSong(song);
        RecentsDatabase recents = getIt<RecentsDatabase>();
        await recents.insertSong(song);
      },
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
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/albumCover/albumCover150x150.jpg",
                    width: 140, height: 140, fit: BoxFit.fill,
                  );
                },
                errorWidget: (context, url, error) {
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
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
            ),
            Text(
              (subtitle.isEmpty) ? song.subtitle : subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11),
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: getIt<AudioManager>().currentSongNotifier,
      builder: (context, mediaItem, _) {
        return ListTile(
          onTap: () => (mediaItem.id == song.id) ? null : getIt<AudioManager>().skipToQueueItem(index),
          tileColor: (mediaItem!.id != song.id) 
              ? null
              : (Theme.of(context).brightness == Brightness.light)
                  ? Colors.black12
                  : Colors.white12,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: song.artUri.toString(), fit: BoxFit.cover, width: 50, height: 50,
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/songCover/songCover50x50.jpg",
                  fit: BoxFit.cover, width: 50, height: 50
                );
              },
              placeholder: (context, url) {
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
            valueListenable: getIt<AudioManager>().playButtonNotifier,
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
            child: Icon(Icons.drag_handle_rounded, color: Colors.white, size: 30,),
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
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      ),
    );
  }

  void _addToPlaylistDialog(BuildContext context) {
    ThemeData theme = Theme.of(context);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent,
          child: SizedBox(
            height: 675,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: 675,
                  child: Column(
                    children: [
                      Spacer(),
                      SizedBox(
                        height: 650,
                        child: AddToPlaylistDialog(song)
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 5, borderRadius: BorderRadius.circular(12),
                  shadowColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
                  color: (theme.brightness == Brightness.light) ? Colors.white : Colors.black,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackgroundGradientDecorator(
                      height: 80,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: song.image.medQuality,
                              height: 50, width: 50, fit: BoxFit.fill,
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  "assets/images/songCover/songCover150x150.jpg",
                                  fit: BoxFit.fill, width: 50, height: 50
                                );
                              },
                              placeholder: (context, url) {
                                return Image.asset(
                                  "assets/images/songCover/songCover150x150.jpg",
                                  fit: BoxFit.fill, width: 50, height: 50
                                );
                              },
                            ),
                          ),
                          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyLarge,),
                          subtitle: Text(song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall,),
                        ),
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void _addToQueueDialog(BuildContext context) {
    ThemeData theme = Theme.of(context);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, shadowColor: Colors.transparent,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                elevation: 5, borderRadius: BorderRadius.circular(12),
                color: Colors.transparent, shadowColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: song.image.medQuality,
                          height: 150, width: 150, fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              "assets/images/songCover/songCover500x500.jpg",
                              fit: BoxFit.fill, width: 150, height: 150
                            );
                          },
                          placeholder: (context, url) {
                            return Image.asset(
                              "assets/images/songCover/songCover500x500.jpg",
                              fit: BoxFit.fill, width: 150, height: 150
                            );
                          },
                        ),
                      ),
                    ),
                    Gap(3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 250, height: 70, color: Colors.black,
                        child: BackgroundGradientDecorator(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                            child: Column(
                              children: [
                                Text(song.title, style: theme.textTheme.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(song.subtitle, style: theme.textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(10),
              AddToQueueDialog(song)
            ],
          ),
        );
      }
    );
  }
}