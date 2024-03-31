import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/details/details_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class ArtistTile extends StatelessWidget {
  final Artist artist;
  final String subtitle;
  ArtistTile(this.artist, {super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: ArtistController(artist),
      builder: (controller) {
        return ListTile(
          onTap: () async {
            RecentsDatabase recents = getIt<RecentsDatabase>();
            await recents.insertArtist(artist);
            Get.to(
              () => ArtistDetailsView(),
              arguments: artist.id
            );
          },
          contentPadding: EdgeInsets.zero,
          leading: ClipOval(
            child: CachedNetworkImage(
              imageUrl: artist.image!.lowQuality,
              fit: BoxFit.cover, width: 50, height: 50,
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/artistCover/artistCover50x50.jpg",
                  fit: BoxFit.cover, width: 50, height: 50
                );
              },
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/artistCover/artistCover50x50.jpg",
                  fit: BoxFit.cover, width: 50, height: 50
                );
              },
            ),
          ),
          horizontalTitleGap: 10,
          title: Text(artist.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
          subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,),
          trailing: ArtistPopUpMenu(artist, controller: controller,),
        );
      }
    );
  }
}

class ArtistCell extends StatelessWidget {
  final Artist artist;
  final String subtitle;
  ArtistCell(this.artist, {super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.to(() => ArtistDetailsView(), arguments: artist.id);
        RecentsDatabase recents = getIt<RecentsDatabase>();
        await recents.insertArtist(artist);
      },
      child: Container(
        width: 160,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: artist.image!.medQuality, fit: BoxFit.fill, height: 140, width: 140,
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/artistCover/artistCover150x150.jpg",
                    fit: BoxFit.fill, height: 140, width: 140
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/artistCover/artistCover150x150.jpg",
                    fit: BoxFit.fill, height: 140, width: 140,
                  );
                },
              ),
            ),
            Gap(2),
            Text(
              artist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)
            ),
            if(subtitle.isNotEmpty)
              Text(
                subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall
              ),
          ],
        ),
      ),
    );
  }
}

class ArtistPopUpMenu extends StatelessWidget {
  final Artist artist;
  final ArtistController controller;
  const ArtistPopUpMenu(this.artist, {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => controller.switchCloned(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(
              icon: (controller.isClone.value) ? Ic.twotone_cyclone : Ic.round_cyclone,
              label: (controller.isClone.value) ? "Remove from Library" : "Clone to Library"
            ),
          ),
          PopupMenuItem(
            onTap: () => controller.switchStarred(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(
              icon: (controller.isStar.value) ? Mi.favorite : Uis.favorite,
              label: (controller.isStar.value) ? "Remove from Star" : "Add to Starred"
            ),
          ),
        ];
      },
      padding: EdgeInsets.zero,
      icon: Iconify(
        Ic.sharp_more_vert, size: 32,
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      ),
    );
  }
}