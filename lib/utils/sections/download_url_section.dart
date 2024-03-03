// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/src/models/download_url.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';

class DownloadUrlSection extends StatelessWidget {
  final DownloadUrl downloadUrl;
  DownloadUrlSection({super.key, required this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => ToDoView(text: "Donwload this song on high quality"));
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.grey.shade800, radius: 40,
                  child: Iconify(Ic.twotone_cloud_download, size: 50, color: Colors.white)
                ),
              ),
              Text("320kbps", style: Get.textTheme.labelMedium),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => ToDoView(text: "Donwload this song on medium quality"));
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.grey.shade800, radius: 40,
                  child: Iconify(Ic.round_download, size: 50, color: Colors.white)
                ),
              ),
              Text("160kbps", style: Get.textTheme.labelMedium),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => ToDoView(text: "Donwload this song on low quality"));
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.grey.shade800, radius: 40,
                  child: Iconify(MaterialSymbols.download_rounded, size: 50, color: Colors.white)
                ),
              ),
              Text("96kbps", style: Get.textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}