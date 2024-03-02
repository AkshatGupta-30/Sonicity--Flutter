// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: BackgroundGradientDecorator(
        child: SafeArea(
          child: Container(
            width: media.width, height: media.height,
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [  
                  Gap(40),
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
                  Gap(10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: "LovelyMamma", fontSize: 18),
                      children: <TextSpan>[
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
                  Gap(50),
                  Text(
                    "It can organise and play audio files stored on your phone, SD card or USB storage",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Gap(5),
                  Row(
                    children: <Iconify>[
                      Iconify(Ic.twotone_phone_android, color: Colors.grey, size: 30),
                      Iconify(Ic.twotone_sd_card, color: Colors.grey, size: 30),
                      Iconify(Ic.twotone_keyboard_arrow_right, color: Colors.grey, size: 30),
                      Iconify(IconParkTwotone.headphone_sound, color: Colors.grey, size: 30),
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