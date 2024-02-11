// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonicity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "LovelyMamma",
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        body: Center(
          child: Text('Sonicity', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
