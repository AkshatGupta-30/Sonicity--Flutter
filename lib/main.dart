// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/views/navigation_view.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      title: 'Sonicity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "LovelyMamma",
        scaffoldBackgroundColor: Colors.black,
      ),
      home: NavigationView(),
    );
  }
}
