// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class ToDoView extends StatelessWidget {
  final Color bgColor, color;
  ToDoView({super.key, this.bgColor = Colors.black, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Text(
          "Comming Soon",
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
    );
  }
}