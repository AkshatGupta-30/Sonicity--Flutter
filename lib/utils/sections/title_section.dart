// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final double leftPadding;
  final bool center;
  final double size;
  TitleSection({
    super.key, required this.title,
    this.leftPadding = 10,
    this.center = false,
    this.size = 27
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: (center) ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.only(left: (center) ? 0 : leftPadding),
      child: Text(title, style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: size)),
    );
  }
}