// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final double leftPadding;
  final bool center;
  final double ? size;
  TitleSection({
    super.key, required this.title,
    this.leftPadding = 10,
    this.center = false,
    this.size
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      alignment: (center) ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.only(left: (center) ? 0 : leftPadding),
      child: Text(title, style: Get.textTheme.titleLarge!.copyWith(color: Get.find<SettingsController>().getAccent, fontSize: size)),
    ));
  }
}