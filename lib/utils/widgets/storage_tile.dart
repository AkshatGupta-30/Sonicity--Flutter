// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:sonicity/utils/widgets/iconify.dart';

class StorageTile extends StatelessWidget {
  final FileSystemEntity entity;
  final VoidCallback onTap;
  StorageTile({super.key, required this.entity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: FileManager.isFile(entity)
        ? Iconify(Ic.twotone_audio_file,)
        : Iconify(IconParkTwotone.folder_music,),
      title: Text(
        FileManager.basename(
          entity,
          showFileExtension: true,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: FutureBuilder<FileStat>(
        future: entity.stat(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (entity is File) {
              int size = snapshot.data!.size;
              return Text(
                FileManager.formatBytes(size),
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }
            return Text(
              "${snapshot.data!.modified}".substring(0, 10),
              style: Theme.of(context).textTheme.bodyMedium,
            );
          } else {
            return Text(
              "error",
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }
        },
      ),
    );
  }
}