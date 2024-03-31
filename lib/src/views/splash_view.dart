import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/splashview_controller.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: SplashViewController(),
        builder: (controller) {
          return BackgroundGradientDecorator(
            child: ScaleTransition(
              scale: controller.scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/appLogo/appLogo500x500.png', width: MediaQuery.sizeOf(context).width/3.75,)
                  ),
                  Gap(10),
                  GlowText(
                    'Sonicity', glowColor: Colors.white, blurRadius: 20,
                    style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            )
          );
        }
      ),
    );
  }
}