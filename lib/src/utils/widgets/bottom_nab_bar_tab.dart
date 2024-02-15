// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:sonicity/src/utils/contants/colors.dart';

class Tabs extends StatelessWidget {
  final int thisTab, selectedTab;
  final String label;
  final IconData icon;

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
        children: [Icon(icon), Text(label, style: TextStyle(fontFamily: 'LovelyMamma'))],
      ),
    );
  }
}