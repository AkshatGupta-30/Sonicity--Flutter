import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/details/details_view.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  AlbumCard(this.album, {super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return GetBuilder(
      global: false,
      init: AlbumController(album),
      builder: (controller) {
        return GestureDetector(
          onTap: () async {
            RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
            await recents.insertAlbum(album);
            Get.to(
              () => AlbumDetailsView(),
              arguments: album.id
            );
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
                    imageUrl: album.image!.highQuality,
                    width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/albumCover/albumCover500x500.jpg",
                        width: media.width/1.25, height: media.width/1.25, fit: BoxFit.fill,
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/images/albumCover/albumCover500x500.jpg",
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
                    children:<Text> [
                      Text(
                        album.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "${album.songCount!} Songs", maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade800 : null
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(top: 0, right: 0, child: AlbumPopUpMenu(album, controller: controller),),
              ],
            ),
          ),
        );
      }
    );
  }
}

class AlbumCell extends StatelessWidget {
  final Album album;
  final String subtitle;
  final CrossAxisAlignment alignment;
  AlbumCell(this.album, {super.key, required this.subtitle, this.alignment  = CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
        await recents.insertAlbum(album);
        Get.to(
          () => AlbumDetailsView(),
          arguments: album.id
        );
      },
      child: Container(
        width: 140,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: album.image!.medQuality,
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
              album.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
            ),
            if(subtitle.isNotEmpty)
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11),
              )
          ],
        ),
      ),
    );
  }
}

class AlbumTile extends StatelessWidget {
  final Album album;
  final String subtitle;
  AlbumTile(this.album, {super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: AlbumController(album),
      builder: (controller) => ListTile(
        onTap: () async {
          RecentsDatabase recents = GetIt.instance<RecentsDatabase>();
          await recents.insertAlbum(album);
          Get.to(
            () => AlbumDetailsView(),
            arguments: album.id
          );
        },
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: album.image!.lowQuality,
            fit: BoxFit.cover, width: 50, height: 50,
            errorWidget: (context, url, error) {
              return Image.asset(
                "assets/images/albumCover/albumCover50x50.jpg",
                fit: BoxFit.cover, width: 50, height: 50
              );
            },
            placeholder: (context, url) {
              return Image.asset(
                "assets/images/albumCover/albumCover50x50.jpg",
                fit: BoxFit.cover, width: 50, height: 50
              );
            },
          ),
        ),
        horizontalTitleGap: 10,
        title: Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,),
        trailing: AlbumPopUpMenu(album, controller: controller,),
      )
    );
  }
}

class AlbumPopUpMenu extends StatelessWidget {
  final Album album;
  final AlbumController controller;
  const AlbumPopUpMenu(this.album, {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => controller.switchCloned(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() => PopUpButtonRow(
              icon: (controller.isClone.value) ? Ic.twotone_cyclone : Ic.round_cyclone,
              label: (controller.isClone.value) ? "Remove from Library" : "Clone to Library"
            ))
          ),
          PopupMenuItem(
            onTap: () => controller.switchStarred(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() => PopUpButtonRow(
              icon: (controller.isStar.value) ? Mi.favorite : Uis.favorite,
              label: (controller.isStar.value) ? "Remove from Star" : "Add to Starred"
            )),
          ),
        ];
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      color: Colors.grey.shade900,
      icon: Iconify(
        Ic.sharp_more_vert, size: 32,
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      ),
    );
  }
}

