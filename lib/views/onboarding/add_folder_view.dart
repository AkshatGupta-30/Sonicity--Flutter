// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/persistence/shared_preference/allowed_directories.dart';
import 'package:sonicity/utils/widgets/folder_tile.dart';

class AddFolderView extends StatelessWidget {
  AddFolderView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: media.width, height: media.height,
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Folders to scan",
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 40),
                ),
                SizedBox(height: 12),
                Text(
                  "Select the folders where you keep your audio files.",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                ),
                SizedBox(height: 15),
                FolderTile(
                  onTap: () {
                    Get.bottomSheet(
                      BottomSheetWidget(),
                    );
                  },
                  color: Colors.cyanAccent,
                  title: "ADD FOLDER",
                  fontSize: 18,
                  icon: Icons.create_new_folder_rounded,
                ),
              ],
            ),
          )
        )
      )
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final RxList<Directory> mediaDirectory = <Directory>[].obs;
  
  @override
  void initState() {
    super.initState();
    getDirectories();
  }

  void getDirectories() async {
    const List<String> paths = [
      "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Audio",
      "/storage/emulated/0/Music"
    ];

    for(String path in paths) {
      Directory directory = Directory(path);
      if(directory.existsSync()) {
        mediaDirectory.add(Directory(path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Color(0xFF151515),
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a folder',
            style: TextStyle(color: Colors.grey.shade200, fontSize: 20),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Folders with full access :',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                SizedBox(height: 20),
                Obx(
                  () {
                    return Wrap(
                      spacing: 15, runSpacing: 15,
                      children: List.generate(
                        mediaDirectory.length,
                        (index) {
                          String title = mediaDirectory[index].path;
                          return FolderTile(
                            onTap: () async {},
                            icon: Icons.phone_android_rounded,
                            title: title.substring(20, title.length).replaceAll("/", " > "),
                          );
                        }
                      )
                    );
                  }
                ),
                SizedBox(height: 20),
                Text(
                  'Select a folder from :',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                SizedBox(height: 20),
                FolderTile(
                  onTap: () async {
                    var pickedFolder = await FilePicker.platform.getDirectoryPath(initialDirectory: "/storage/emulated/0");
                    if (pickedFolder != null) {
                      AllowedDirectories.update(pickedFolder, isAdded: true);
                    }
                  },
                  icon: Icons.phone_android,
                  title: "Internal Storage",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
