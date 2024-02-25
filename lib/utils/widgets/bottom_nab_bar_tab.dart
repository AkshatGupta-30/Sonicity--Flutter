// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:sonicity/utils/contants/colors.dart';

class Tabs extends StatelessWidget {
  final int thisTab, selectedTab;
  final String label;
  final String icon;

  Tabs({
    super.key,
    required this.thisTab, required this.selectedTab, required this.icon, required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (thisTab == selectedTab) ? accentColorDark : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Iconify(icon, color: (thisTab == selectedTab) ? accentColor : Colors.white),
          Text(label, style: TextStyle(fontFamily: 'LovelyMamma'))
        ],
      ),
    );
  }
}