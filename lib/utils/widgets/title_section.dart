// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final double leftPadding;
  TitleSection({super.key, required this.title, this.leftPadding = 10});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Text(title, style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }
}