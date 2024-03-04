// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/storage_tile.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class StorageView extends StatefulWidget {
  StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  late Rx<Directory> curDir = Directory("storage/emulated/0/Music").obs;
  late RxInt currentDirItemCount = 0.obs;
  late RxInt songCounts = 0.obs;

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  void initAsync() async {
    if(!await Permission.storage.request().isGranted) {
      currentDirItemCount.value = curDir.value.listSync().length;
    }
    songCounts.value = await countSongs(curDir.value);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var safe = MediaQuery.of(context).padding;
    return Obx(() => PopScope(
      canPop: (curDir.value.path == "storage/emulated/0/Music"),
      onPopInvoked: (didPop) {
        if(curDir.value.path != "storage/emulated/0/Music") {
          curDir.value = curDir.value.parent;
        }
        updateAppBar();
      },
      child: Scaffold(
        body: BackgroundGradientDecorator(
          child: CustomScrollView(
            slivers: [
              appBar(media, safe),
              SliverList.builder(
                itemCount: curDir.value.listSync().length,
                itemBuilder: (context, index) {
                  FileSystemEntity entity = curDir.value.listSync()[index];
                  String entityName = rootName(entity.path);
                  if (entityName[0] == ".") return SizedBox();
                  return StorageTile(
                    entity: entity,
                    onTap: () {
                      curDir.value = Directory(entity.path);
                      updateAppBar();
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    ));
  }

  SliverAppBar appBar(Size media, EdgeInsets safe) {
    return SliverAppBar(
      leading: BackButton(
        onPressed: () {
          if(curDir.value.path != "storage/emulated/0/Music") {
            curDir.value = curDir.value.parent;
          } else {
            Get.back();
          }
          updateAppBar();
        },
      ),
      title: Text(rootName(curDir.value.path)),
      bottom: PreferredSize(
        preferredSize: Size(media.width, kBottomNavigationBarHeight + safe.top),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                curDir.value.path.substring(19, curDir.value.path.length).replaceAll('/', ' \u203A '), textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
              ),
              Gap(5),
              Row(
                children: [
                  Text(
                    "${songCounts.value} Songs\t\t\t", textAlign: TextAlign.start,
                    style: Get.textTheme.labelMedium,
                  ),
                  Iconify(
                    Ri.timer_flash_line, size: 18,
                    color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                  Text(
                    " 0 Minutes", textAlign: TextAlign.start,
                    style: Get.textTheme.labelMedium,
                  ),
                ],
              ),
              Gap(5),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void updateAppBar() async {
    songCounts.value = await countSongs(curDir.value);
  }

  Future<int> countSongs(Directory directory) async {
    int count = 0;
    List<FileSystemEntity> entities = directory.listSync();
    for (var entity in entities) {
      if(entity is Directory) {
        if (rootName(entity.path)[0] != ".") {
          int newCount = await countSongs(entity);
          count = count + newCount;
        }
      } else {
        String extension = entity.path.split('.').last.toLowerCase();
        if (extension == 'mp3' || extension == 'wav' || extension == 'ogg') {
          count++;
        }
      }
    }
    return count;
  }

  String rootName(String path) {
    String newPath = path.substring(path.lastIndexOf('/'), path.length);
    if (newPath.startsWith('/')) {
      newPath = newPath.substring(1, newPath.length);
    }
    return newPath;
  }
}