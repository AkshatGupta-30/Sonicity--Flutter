import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';

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
    final theme = Theme.of(context);
    return Obx(() => Container(
      alignment: (center) ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.only(left: (center) ? 0 : leftPadding),
      child: Text(title, style: theme.textTheme.titleLarge!.copyWith(color: Get.find<SettingsController>().getAccent, fontSize: size)),
    ));
  }
}