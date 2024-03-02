// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/views/details/artist_details_view.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';

class ArtistTile extends StatelessWidget {
  final Artist artist;
  final String subtitle;
  ArtistTile({super.key,required this.artist, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(
          () => ArtistDetailsView(),
          arguments: artist.id
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: artist.image!.lowQuality,
          fit: BoxFit.cover, width: 50, height: 50,
          errorWidget: (context, url, error) {
            return Image.asset(
              "assets/images/appLogo50x50.png",
              fit: BoxFit.cover, width: 50, height: 50
            );
          },
          placeholder: (context, url) {
            return Image.asset(
              "assets/images/appLogo50x50.png",
              fit: BoxFit.cover, width: 50, height: 50
            );
          },
        ),
      ),
      horizontalTitleGap: 10,
      title: Text(
        artist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      trailing: ArtistPopUpMenu(artist),
    );
  }
}

class ArtistPopUpMenu extends StatelessWidget {
  final Artist artist;
  const ArtistPopUpMenu(this.artist, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Ic.round_cyclone, label: "Clone to Library"),
          ),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PopUpButtonRow(icon: Mi.favorite, label: "Add to Starred"),
          ),
        ];
      },
      padding: EdgeInsets.zero,
      icon: Iconify(Ic.sharp_more_vert, color: Colors.grey.shade100, size: 32),
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
      onTap: () {
        Get.to(
          () => ArtistDetailsView(),
          arguments: artist.id
        );
      },
      child: Container(
        width: 160,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: artist.image!.standardQuality, fit: BoxFit.fill, height: 140, width: 140,
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/appLogo150x150.png",
                    fit: BoxFit.fill, height: 140, width: 140
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/appLogo150x150.png",
                    fit: BoxFit.fill, height: 140, width: 140,
                  );
                },
              ),
            ),
            Gap(2),
            Text(
              artist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade50, fontSize: 16)
            ),
            if(subtitle.isNotEmpty)
              Text(
                subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12)
              ),
          ],
        ),
      ),
    );
  }
}