// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FolderTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final Color color;
  final double fontSize;

  FolderTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.color = Colors.grey,
    this.fontSize = 15
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: color.withOpacity(0.25),
      splashFactory: InkSplash.splashFactory,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 27),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                title, overflow: TextOverflow.visible, maxLines: null,
                style: TextStyle(color: color, fontSize: fontSize),
              ),
            )
          ],
        )
      ),
    );
  }
}