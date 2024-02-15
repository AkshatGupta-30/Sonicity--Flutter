// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: media.width, height: media.height,
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [  
                  SizedBox(height: 40),
                  Container(
                    width: 100,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      shape: BoxShape.circle
                    ),
                    child: ClipOval(
                      child: Image.asset("assets/images/appLogo150x150.png"),
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: "LovelyMamma", fontSize: 18),
                      children: [
                        TextSpan(
                          text: "Welcome to Sonicity!",
                          style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                          text: " Your ultimate music companion.",
                          style: TextStyle(color: Colors.grey)
                        ),
                      ]
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "It can organise and play audio files stored on your phone, SD card or USB storage",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Icon>[
                      Icon(Icons.phone_android, color: Colors.grey, size: 30),
                      Icon(Icons.sd_card, color: Colors.grey, size: 30),
                      Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30),
                      Icon(Icons.headphones, color: Colors.grey, size: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}