// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/persistence/shared_preference/allowed_directories.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/storage_tile.dart';

class StorageView extends StatefulWidget {
  StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  late bool correctPath = false;
  late RxList<String> allowedDirectories = <String>[].obs;
  RxBool inAllowedDirectories = true.obs;

  final FileManagerController fileManagerController = Get.put(FileManagerController());

  String currentFolder = "Storage";
  String currentPath = "Storage";
  int songCount = 0;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  void initAsync() async {
    allowedDirectories.value = await AllowedDirectories.load();
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
          initAsync();
          return ControlBackButton(
            controller: fileManagerController,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: CustomScrollView(
                  physics: (allowedDirectories.isEmpty) ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                  slivers: [
                    appBar(media, safe),
                    SliverToBoxAdapter(
                      child: (allowedDirectories.isEmpty)
                      ? blank()
                      : operateAllowedDirectories()
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  String? directoryPath = await FilePicker.platform.getDirectoryPath();
                  if (directoryPath != null) {
                    AllowedDirectories.update(directoryPath, isAdded: true);
                  }
                },
                backgroundColor: accentColor,
                child: Icon(Icons.create_new_folder_rounded, size: 30),
              ),
            )
          );
        }
      ),
    );
  }

  Widget blank() {
    return Center(
      child: Text(
        "No Folders to Show",
        style: TextStyle(color: Colors.redAccent, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  SliverAppBar appBar(Size media, EdgeInsets safe) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      leading: Icon(Icons.folder_special_rounded, color: Colors.white, size: 30),
      title: Text(
        currentFolder,
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
                currentPath.replaceAll("/", ">"), textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "$songCount Songs\t\t\t", textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
                  ),
                  Icon(Icons.timer_outlined, color: Colors.grey.shade300, size: 18),
                  Text(
                    " ${totalDuration.inMinutes} Minutes", textAlign: TextAlign.start,
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

  Widget operateAllowedDirectories() {
    return FileManager(
      controller: fileManagerController,
      builder: (context, _) {
        if(allowedDirectories.length==1) {
          FileSystemEntity entity = Directory(allowedDirectories.first);
          return singleEntity(entity);
        } else {
          List<FileSystemEntity> entities = [];
          for(var path in allowedDirectories) {
            entities.add(Directory(path));
          }
          return multipleEntities(entities);
        }
      },
    );
  }

  Widget singleEntity(FileSystemEntity entity) {
    return SizedBox(
      height: 72,
      child: StorageTile(
        entity: entity,
        onTap: () {
          if (FileManager.isDirectory(entity)) {
            if(allowedDirectories.contains(entity.path)) {
              inAllowedDirectories.value = false;
            }
            fileManagerController.openDirectory(entity);
          }
        },
        onLongPress: () {
          if(allowedDirectories.contains(entity.path)) {
            AllowedDirectories.update(entity.path, isAdded: false);
          }
        },
      ),
    );
  }

  Widget multipleEntities(List<FileSystemEntity> entities) {
    return SizedBox(
      height: entities.length * 72,
      child: ListView.builder(
        itemCount: entities.length,
        itemBuilder: (context, index) {
          FileSystemEntity entity = entities[index];
          return StorageTile(
            entity: entity,
            onTap: () async {
              if (FileManager.isDirectory(entity)) {
                fileManagerController.openDirectory(entity);
              }
            },
            onLongPress: () {
              if(allowedDirectories.contains(entity.path)) {
                AllowedDirectories.update(entity.path, isAdded: false);
              }
            },
          );
        },
      ),
    );
  }
}