import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sonicity/utils/widgets/iconify.dart';

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
        Iconify(
          icon, size: 22,
          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
        ),
        Gap(10),
        Text(label, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
      ],
    );
  }
}
