// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';

class SearchHistoryCell extends StatelessWidget {
  final String itemText;
  final VoidCallback onTap, onRemove;
  SearchHistoryCell({super.key, required this.itemText, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFF3d3d3d),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Text(
                itemText,
                style: Get.textTheme.labelSmall!.copyWith(color: Colors.white),
              ),
            ),
            Gap(8),
            GestureDetector(
              onTap: onRemove,
              child: Iconify(Ri.close_circle_fill, size: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}