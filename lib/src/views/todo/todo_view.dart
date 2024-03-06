import 'package:flutter/material.dart';

class ToDoView extends StatelessWidget {
  final String text;
  ToDoView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30)),
      ),
    );
  }
}