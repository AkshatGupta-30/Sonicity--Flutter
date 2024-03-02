// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:sonicity/utils/sections/title_section.dart';

class ViewAllSection extends StatelessWidget {
  final double leftPadding, rightPadding;
  final String title;
  final String buttonTitle;
  final VoidCallback onPressed;
  final double size;
  ViewAllSection({
    super.key, required this.title, required this.buttonTitle, required this.onPressed,
    this.leftPadding = 5, this.rightPadding = 10, this.size = 27
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding, left: leftPadding),
      child: Row(
        children: [
          TitleSection(title: title, leftPadding: leftPadding, size: size),
          Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            child: Row(
              children: [
                Text(
                  buttonTitle,
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Iconify(Ic.baseline_keyboard_arrow_right, color: Colors.grey)
              ],
            ),
          )
        ],
      ),
    );
  }
}