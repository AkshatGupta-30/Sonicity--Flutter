// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/utils/widgets/storage_tile.dart';

class StorageView extends StatefulWidget {
  StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  late Rx<Directory> musicDir = Directory("storage/emulated/0/").obs;
  late RxInt currentDirectoryItemCount = 0.obs;

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  void initAsync() async {
    bool isMusicDirPresent = await Directory("storage/emulated/0/Music").exists();
    if(!isMusicDirPresent) {
      musicDir.value = await Directory("storage/emulated/0/Music").create();
    }
    musicDir.value = Directory("storage/emulated/0/Music");
    currentDirectoryItemCount.value = musicDir.value.listSync().length;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    var safe = MediaQuery.paddingOf(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Obx(
        () {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              slivers: [
                appBar(media, safe),
                SliverList.builder(
                  itemCount: currentDirectoryItemCount.value,
                  itemBuilder: (context, index) {
                    FileSystemEntity entity = musicDir.value.listSync()[index];
                    String entityName = rootName(entity.path);
                    if (entityName[0] == ".") return SizedBox();
                    return StorageTile(
                      entity: entity,
                      onTap: openDirectory,
                    );
                  },
                )
              ],
            ),
          );
        }
      ),
    );
  }

  SliverAppBar appBar(Size media, EdgeInsets safe) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      leading: Icon(Icons.folder_special_rounded, color: Colors.white, size: 30),
      title: Text(
        "Path",
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      toolbarHeight: kBottomNavigationBarHeight,
      bottom: PreferredSize(
        preferredSize: Size(media.width, kBottomNavigationBarHeight + safe.top),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "storage/emulated/0", textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "0 Songs\t\t\t", textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
                  ),
                  Icon(Icons.timer_outlined, color: Colors.grey.shade300, size: 18),
                  Text(
                    " 0 Minutes", textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(color: Colors.white.withOpacity(0.25)),
            ],
          ),
        ),
      ),
    );
  }

  void openDirectory() async {

  }

  String rootName(String path) {
    String newPath = path.substring(path.lastIndexOf('/'), path.length);
    if (newPath.startsWith('/')) {
      newPath = newPath.substring(1, newPath.length);
    }
    return newPath;
  }

  String parentDirectory(String path) {
    String newPath = path.substring(0, path.lastIndexOf('/'));
    if (newPath.endsWith('/')) {
      newPath = newPath.substring(0, newPath.length - 1);
    }
    return newPath;
  }
}