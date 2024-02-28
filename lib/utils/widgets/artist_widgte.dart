// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';

class ArtistRow extends StatelessWidget {
  final Artist artist;
  final String subtitle;
  ArtistRow({super.key,required this.artist, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: artist.image!.lowQuality,
                fit: BoxFit.cover, width: 60, height: 60,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/appLogo50x50.png",
                    fit: BoxFit.cover, width: 60, height: 60
                  );
                },
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/appLogo50x50.png",
                    fit: BoxFit.cover, width: 60, height: 60
                  );
                },
              ),
            ),
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 26,
                    child: Text(
                      artist.name,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ),
                  SizedBox(
                    height: 20,
                    child: Text(
                      subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ),
                ],
              ),
            ),
            PopupMenuButton(
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.zero,
              position: PopupMenuPosition.under,
              color: Colors.grey.shade900,
              icon: Iconify(Ic.sharp_more_vert, color: Colors.grey.shade100, size: 32),
            )
          ]
        ),
      ),
    );
  }
}
