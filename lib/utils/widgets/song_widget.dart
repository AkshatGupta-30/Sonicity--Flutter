import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter_plus/icons/entypo.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:sonicity/src/controllers/song_controller.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/views/details/album_details_view.dart';
import 'package:sonicity/src/views/details/song_details_view.dart';
import 'package:sonicity/src/views/player/main_player_view.dart';
import 'package:sonicity/utils/sections/add_to_playlist_section.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

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
            Get.to(() => MainPlayerView(song: song, controller: controller));
            RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
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
            Get.to(() => MainPlayerView(song: song, controller: controller));
          RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
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
            onTap: () {
              Get.to(
                () => AlbumDetailsView(),
                arguments: song.album!.id
              );
            },
            child: PopUpButtonRow(icon: MaterialSymbols.album, label: "View Album"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            onTap: () {
              Get.to(
                () => SongDetailsView(),
                arguments: song.id
              );
            },
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
}