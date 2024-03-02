// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

class PopUpButtonRow extends StatelessWidget {
  PopUpButtonRow({
    super.key,
    required this.icon,
    required this.label,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Iconify(icon, color: Colors.grey.shade100, size: 22),
        Gap(10),
        Text(label),
      ],
    );
  }
}
