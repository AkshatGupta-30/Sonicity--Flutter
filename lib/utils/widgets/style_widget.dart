// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class BackgroundGradientDecorator extends StatelessWidget {
  final Widget child;
  BackgroundGradientDecorator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          stops: const [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: child,
    );
  }
}