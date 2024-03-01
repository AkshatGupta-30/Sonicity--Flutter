// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/pepicons.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionView extends StatelessWidget {
  final PageController pageController;
  PermissionView({super.key, required this.pageController});

  final Rx<Permission> audioAccess = Permission.audio.obs;
  final permission = false.obs;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: media.width, height: media.height,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Iconify(Ic.twotone_music_note, color: Colors.white, size: 50),
                Gap(20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontFamily: "LovelyMamma", fontSize: 18),
                    children: [
                      TextSpan(
                        text: "Sonicity requires ",
                        style: TextStyle(color: Colors.grey)
                      ),
                      TextSpan(
                        text: "Music and audio",
                        style: TextStyle(color: Colors.cyanAccent)
                      ),
                      TextSpan(
                        text: " permission",
                        style: TextStyle(color: Colors.grey)
                      )
                    ]
                  ),
                ),
                Gap(20),
                Obx(() {
                  permissionStatus();
                  return (permission.value == false)
                  ? ListTile(
                    onTap: () async {
                      permission.value = await requestPermission();
                      if(permission.value) {
                        Future.delayed(
                          Duration(milliseconds: 750),
                          () => pageController.nextPage(
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInOut
                          )
                        );
                      }
                    },
                    tileColor: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Iconify(Pepicons.music_note_double, color: Colors.black),
                    title: Text(
                      "MUSIC AND AUDIO PERMISSION",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Iconify(Ic.twotone_check_circle, color: Colors.cyanAccent),
                      Gap(10),
                      Text(
                        "Premission is granted",
                        style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ]
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void permissionStatus() async {
    permission.value = await audioAccess.value.isGranted;
    
  }

  Future<bool> requestPermission() async {
    PermissionStatus result = await audioAccess.value.status;
    if(result == PermissionStatus.denied || result == PermissionStatus.restricted) {
      await audioAccess.value.request();
      result = await audioAccess.value.request();
    }
    return result.isGranted;
  }
}