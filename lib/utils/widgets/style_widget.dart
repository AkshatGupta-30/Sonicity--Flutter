import 'package:flutter/material.dart';

class BackgroundGradientDecorator extends StatelessWidget {
  final Widget child;
  final double? width, height;
  BackgroundGradientDecorator({super.key, required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height ?? double.maxFinite, width: width ?? double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: (theme.brightness == Brightness.light) 
            ? [Colors.grey.shade100, Colors.grey.shade100.withOpacity(0.3)]
            : [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          stops: const [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: child,
    );
  }
}