// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

class StorageTile extends StatelessWidget {
  final FileSystemEntity entity;
  final VoidCallback onTap;
  StorageTile({super.key, required this.entity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: FileManager.isFile(entity)
        ? Icon(Icons.feed_outlined, color: Colors.white,)
        : Icon(Icons.folder, color: Colors.white),
      title: Text(
        FileManager.basename(
          entity,
          showFileExtension: true,
        ),
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: FutureBuilder<FileStat>(
        future: entity.stat(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (entity is File) {
              int size = snapshot.data!.size;
              return Text(
                FileManager.formatBytes(size),
                style: TextStyle(color: Colors.grey.shade300),
              );
            }
            return Text(
              "${snapshot.data!.modified}".substring(0, 10),
              style: TextStyle(color: Colors.grey.shade300),
            );
          } else {
            return Text(
              "error",
              style: TextStyle(color: Colors.grey.shade300),
            );
          }
        },
      ),
    );
  }
}