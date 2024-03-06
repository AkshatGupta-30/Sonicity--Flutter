import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ant_design.dart';
import 'package:iconify_flutter_plus/icons/heroicons.dart';
import 'package:sonicity/src/persistence/shared_preference/allowed_directories.dart';
import 'package:sonicity/utils/widgets/folder_tile.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class AddFolderView extends StatelessWidget {
  AddFolderView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: BackgroundGradientDecorator(
        child: SafeArea(
          child: Container(
            width: media.width, height: media.height,
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Folders to scan",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Gap(12),
                Text(
                  "Select the folders where you keep your audio files.",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Gap(15),
                FolderTile(
                  onTap: () {
                    Get.bottomSheet(
                      BottomSheetWidget(),
                    );
                  },
                  color: Colors.cyanAccent,
                  title: "ADD FOLDER",
                  fontSize: 18,
                  icon: AntDesign.folder_add_twotone,
                ),
              ],
            ),
          )
        ),
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
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Gap(20),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Folders with full access :',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Gap(20),
                Obx(() => Wrap(
                  spacing: 15, runSpacing: 15,
                  children: List.generate(
                    mediaDirectory.length,
                    (index) {
                      String title = mediaDirectory[index].path;
                      return FolderTile(
                        onTap: () async {},
                        icon: Heroicons.device_phone_mobile_20_solid,
                        title: title.substring(20, title.length).replaceAll("/", " > "),
                      );
                    }
                  )
                )),
                Gap(20),
                Text(
                  'Select a folder from :',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Gap(20),
                FolderTile(
                  onTap: () async {
                    var pickedFolder = await FilePicker.platform.getDirectoryPath(initialDirectory: "/storage/emulated/0");
                    if (pickedFolder != null) {
                      AllowedDirectories.update(pickedFolder, isAdded: true);
                    }
                  },
                  icon: Heroicons.device_phone_mobile_20_solid,
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
