// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundGradientDecorator extends StatelessWidget {
  final Widget child;
  BackgroundGradientDecorator({super.key, required this.child});

  final lightColorList = [Colors.grey.shade100, Colors.grey.shade100.withOpacity(0.3)];
  final darkColorList = [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite, width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: (Get.theme.brightness == Brightness.light) ? lightColorList : darkColorList,
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          stops: const [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: child,
    );
  }
}