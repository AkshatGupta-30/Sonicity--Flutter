// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/utils/contants/colors.dart';

enum Quality {low, med, high}

class CoverImageSection extends StatelessWidget {
  final ImageUrl image;
  CoverImageSection({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _column(
            Quality.high, image.highQuality,
            () {
              FlutterClipboard.copy(image.highQuality).then(
                (value) => Get.showSnackbar(GetSnackBar(
                  messageText: Row(
                    children: [
                      Text(
                        "Copied cover image high quality url",
                        style: TextStyle(color: accentColor, fontSize: 18),
                      ),
                      Iconify(MaterialSymbols.done, color: Colors.greenAccent, size: 25),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ))
              );
            }
          ),
          Container(width: 0.5, height: 150, color: Colors.white38),
          _column(
            Quality.med, image.highQuality,
            () {
              FlutterClipboard.copy(image.standardQuality).then(
                (value) => Get.showSnackbar(GetSnackBar(
                  messageText: Row(
                    children: [
                      Text(
                        "Copied cover image medium quality url",
                        style: TextStyle(color: accentColor, fontSize: 18),
                      ),
                      Iconify(MaterialSymbols.done, color: Colors.greenAccent, size: 25),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ))
              );
            }
          ),
          Container(width: 0.5, height: 150, color: Colors.white38),
          _column(
            Quality.low, image.highQuality,
            () {
              FlutterClipboard.copy(image.lowQuality).then(
                (value) => Get.showSnackbar(GetSnackBar(
                  messageText: Row(
                    children: [
                      Text(
                        "Copied cover image low quality url",
                        style: TextStyle(color: accentColor, fontSize: 18),
                      ),
                      Iconify(MaterialSymbols.done, color: Colors.greenAccent, size: 25),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ))
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _column(Quality q, String url, VoidCallback onTap) {
    String quality = (q == Quality.high)
      ? "High Quality"
      : ((q == Quality.med) ? "Medium Quality" : "Low Quality");
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        children: [
          Text(quality, style: TextStyle(color: Colors.white, fontSize: 16)),
          Gap(4),
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: url, fit: BoxFit.cover, height: 120, width: 120,
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/appLogo500x500.png",
                    fit: BoxFit.cover, height: 120, width: 120
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/appLogo500x500.png",
                    fit: BoxFit.cover, height: 120, width: 120,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}