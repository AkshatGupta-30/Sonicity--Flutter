// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sonicity/src/views/navigation_view.dart';
import 'package:sonicity/src/views/onboarding/add_folder_view.dart';
import 'package:sonicity/src/views/onboarding/permission_view.dart';
import 'package:sonicity/src/views/onboarding/welcome_view.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({super.key});

  final PageController onBoardingPageController = PageController();
  final firstPage = true.obs, lastPage = false.obs;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Obx(
      () {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: onBoardingPageController,
              // physics: NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                if(page==0) {
                  firstPage.value = true;
                } else if(page == 2) {
                  lastPage.value = true;
                } else{
                  firstPage.value = false;
                  lastPage.value = false;
                }
              },
              children: [
                WelcomeView(),
                PermissionView(pageController: onBoardingPageController,),
                AddFolderView()
              ],
            ),
            Container(
              width: media.width, height: media.width/3,
              color: Colors.black.withOpacity(0.25),
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (firstPage.value)
                    ? SizedBox(width: 50)
                    : GestureDetector(
                      onTap: () {
                        onBoardingPageController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                      },
                      child: CircleAvatar(
                        radius: 25, backgroundColor: Colors.grey.shade800,
                        child: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 30),
                      ),
                    ),
                  SmoothPageIndicator(
                    controller: onBoardingPageController,
                    count: 3,
                    axisDirection: Axis.horizontal,
                    effect: ColorTransitionEffect(
                      activeDotColor: Colors.cyanAccent, dotColor: Colors.grey,
                      dotHeight: 8, dotWidth: 8,
                    ),
                  ),
                  (lastPage.value)
                    ? GestureDetector(
                      onTap: () {
                        Get.offAll(NavigationView());
                      },
                      child: CircleAvatar(
                        radius: 25, backgroundColor: Colors.cyanAccent,
                        child: Icon(Icons.done_rounded, color: Colors.black, size: 30),
                      ),
                    )
                    : GestureDetector(
                      onTap: () {
                        onBoardingPageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                      },
                      child: CircleAvatar(
                        radius: 25, backgroundColor: Colors.cyanAccent,
                        child: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30),
                      ),
                    ),
                ],
              ),
            )
          ],
        );
      }
    );
  }
}