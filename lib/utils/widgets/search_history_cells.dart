// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SearchHistoryCell extends StatelessWidget {
  final String itemText;
  final VoidCallback onTap, onRemove;
  const SearchHistoryCell({super.key, required this.itemText, required this.onTap, required this.onRemove});

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
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal, ),
              ),
            ),
            SizedBox(width: 8,),
            GestureDetector(
              onTap: onRemove,
              child: CircleAvatar(
                backgroundColor: Colors.white, radius: 8,
                child: Icon(Icons.close, size: 15, color: Color(0xFF3d3d3d)),
              ),
            )
          ],
        ),
      ),
    );
  }
}