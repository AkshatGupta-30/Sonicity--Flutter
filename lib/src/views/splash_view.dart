import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:sonicity/src/controllers/splashview_controller.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splashCover/splashCover300.png'),
            fit: BoxFit.cover, opacity: 0.5
          )
        ),
        child: GetBuilder(
          init: SplashViewController(),
          builder: (controller) {
            return ScaleTransition(
              scale: controller.scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedGradientBorder(
                    gradientColors: [Colors.white], borderSize: 0.2,
                    borderRadius: BorderRadius.circular(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/appLogo/appLogo500x500.png', width: MediaQuery.sizeOf(context).width/3.75,)
                    ),
                  ),
                  Gap(10),
                  GlowText(
                    'Sonicity', glowColor: Colors.white, blurRadius: 20,
                    style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          }
        )
      ),
    );
  }
}