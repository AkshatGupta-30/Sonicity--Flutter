// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonicity/src/views/navigation_view.dart';

void main() {
  // GoogleFonts.config.allowRuntimeFetching = false;
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      darkTheme: FeedbackThemeData.dark(),
      child: GetMaterialApp(
        themeMode: ThemeMode.dark,
        title: 'Sonicity',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "LovelyMamma",
          scaffoldBackgroundColor: Colors.black,
        ),
        home: NavigationView(),
      ),
    );
  }
}
