// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/src/controllers/navigation_controller.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';

class MyTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    fontFamily: Get.find<SettingsController>().fontFamily.value,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) {
        return Iconify(MaterialSymbols.arrow_back_rounded, color: Colors.grey.shade200);
      },
      closeButtonIconBuilder: (context) {
        return Iconify(MaterialSymbols.close_rounded, color: Colors.grey.shade200);
      },
      drawerButtonIconBuilder: (context) {
        return GestureDetector(
          onTap: () => Get.find<NavigationController>().openDrawer(),
          child: Iconify(MaterialSymbols.line_weight_rounded, color: Colors.grey.shade200)
        );
      },
      endDrawerButtonIconBuilder: (context) {
        return GestureDetector(
          onTap: () => Get.find<NavigationController>().openDrawer(),
          child: Iconify(MaterialSymbols.line_weight_rounded, color: Colors.grey.shade200)
        );
      },
    ),
    drawerTheme: DrawerThemeData(
      scrimColor: Colors.black45,
      backgroundColor: Colors.black,
      elevation: 2,
      shadowColor: Colors.white60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      width: 300,
    ),
    appBarTheme: AppBarTheme(
      elevation: 2, toolbarHeight: kToolbarHeight,
      backgroundColor: Colors.grey.shade900,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.grey.shade900,
      centerTitle: true,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: Get.find<SettingsController>().fontFamily.value),
      actionsIconTheme: IconThemeData(color: Colors.grey.shade200),
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: Colors.red,
      dividerColor: Colors.red.withOpacity(0.5),
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      labelColor: Get.find<SettingsController>().getAccent,
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Get.find<SettingsController>().fontFamily.value),
      unselectedLabelColor: Get.find<SettingsController>().getAccentDark,
      unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: Get.find<SettingsController>().fontFamily.value),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
        shadowColor: MaterialStatePropertyAll(Colors.transparent),
        surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
        overlayColor: MaterialStatePropertyAll(Colors.grey.shade900),
        padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10)),
        splashFactory: InkRipple.splashFactory
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white12,
      thickness: 1, space: 1
    ),
    listTileTheme: ListTileThemeData(
      dense: false,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: Get.find<SettingsController>().fontFamily.value),
      subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: Get.find<SettingsController>().fontFamily.value),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      color: Colors.grey.shade900,
      labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade100, fontSize: 18, fontFamily: Get.find<SettingsController>().fontFamily.value)),
    ),
    tooltipTheme: TooltipThemeData(
      preferBelow: false,
      waitDuration: Duration(milliseconds: 500),
      showDuration: Duration(seconds: 2),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 2,
      backgroundColor: Colors.black,
      selectedItemColor: Get.find<SettingsController>().getAccent,
      unselectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(color: Get.find<SettingsController>().getAccent, size: 30),
      unselectedIconTheme: IconThemeData(color: Colors.white, size: 30),
      showSelectedLabels: true, showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontFamily: Get.find<SettingsController>().fontFamily.value, fontSize: 18),
      unselectedLabelStyle: TextStyle(fontFamily: Get.find<SettingsController>().fontFamily.value, fontSize: 18),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontSize: 72, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.grey.shade300, fontSize: 56, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(color: Colors.grey, fontSize: 42, fontWeight: FontWeight.normal),

      headlineLarge: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.grey.shade300, fontSize: 36, fontWeight: FontWeight.w300),
      headlineSmall: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.normal),

      titleLarge: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.grey.shade300, fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 0.15),
      titleSmall: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.normal, letterSpacing: 0.1),

      labelLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.1),
      labelMedium: TextStyle(color: Colors.grey.shade300, fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 0.5),
      labelSmall: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: 0.5),

      bodyLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.15),
      bodyMedium: TextStyle(color: Colors.grey.shade300, fontSize: 15, fontWeight: FontWeight.w300, letterSpacing: 0.25),
      bodySmall: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0.4),
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: Get.find<SettingsController>().fontFamily.value,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) {
        return Iconify(MaterialSymbols.arrow_back_rounded, color: Colors.grey.shade800);
      },
      closeButtonIconBuilder: (context) {
        return Iconify(MaterialSymbols.close_rounded, color: Colors.grey.shade800);
      },
      drawerButtonIconBuilder: (context) {
        return GestureDetector(
          onTap: () => Get.find<NavigationController>().openDrawer(),
          child: Iconify(MaterialSymbols.line_weight_rounded, color: Colors.grey.shade800)
        );
      },
      endDrawerButtonIconBuilder: (context) {
        return GestureDetector(
          onTap: () => Get.find<NavigationController>().openDrawer(),
          child: Iconify(MaterialSymbols.line_weight_rounded, color: Colors.grey.shade800)
        );
      },
    ),
    drawerTheme: DrawerThemeData(
      scrimColor: Colors.white38,
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      width: 300,
    ),
    appBarTheme: AppBarTheme(
      elevation: 2, toolbarHeight: kToolbarHeight,
      backgroundColor: Colors.grey.shade100,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.grey.shade100,
      centerTitle: true,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: Get.find<SettingsController>().fontFamily.value),
      actionsIconTheme: IconThemeData(color: Colors.grey.shade800),
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: Colors.red,
      dividerColor: Colors.red.withOpacity(0.5),
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      labelColor: Get.find<SettingsController>().getAccent,
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Get.find<SettingsController>().fontFamily.value),
      unselectedLabelColor: Get.find<SettingsController>().getAccentDark,
      unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: Get.find<SettingsController>().fontFamily.value),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
        shadowColor: MaterialStatePropertyAll(Colors.transparent),
        surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
        overlayColor: MaterialStatePropertyAll(Colors.grey.shade100),
        padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10)),
        splashFactory: InkRipple.splashFactory
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.black12,
      thickness: 1, space: 1
    ),
    listTileTheme: ListTileThemeData(
      dense: false,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontFamily: Get.find<SettingsController>().fontFamily.value),
      subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: Get.find<SettingsController>().fontFamily.value),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      color: Colors.grey.shade100,
      labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade100, fontSize: 18, fontFamily: Get.find<SettingsController>().fontFamily.value)),
    ),
    tooltipTheme: TooltipThemeData(
      preferBelow: false,
      waitDuration: Duration(milliseconds: 500),
      showDuration: Duration(seconds: 2),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 2,
      backgroundColor: Colors.white,
      selectedItemColor: Get.find<SettingsController>().getAccent,
      unselectedItemColor: Colors.black,
      selectedIconTheme: IconThemeData(color: Get.find<SettingsController>().getAccent, size: 30),
      unselectedIconTheme: IconThemeData(color: Colors.black, size: 30),
      showSelectedLabels: true, showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontFamily: Get.find<SettingsController>().fontFamily.value, fontSize: 18),
      unselectedLabelStyle: TextStyle(fontFamily: Get.find<SettingsController>().fontFamily.value, fontSize: 18),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.black, fontSize: 72, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.grey.shade700, fontSize: 56, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(color: Colors.grey, fontSize: 42, fontWeight: FontWeight.normal),

      headlineLarge: TextStyle(color: Colors.black, fontSize: 48, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.grey.shade700, fontSize: 36, fontWeight: FontWeight.w300),
      headlineSmall: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.normal),

      titleLarge: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.grey.shade700, fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 0.15),
      titleSmall: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.normal, letterSpacing: 0.1),

      labelLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.1),
      labelMedium: TextStyle(color: Colors.grey.shade700, fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 0.5),
      labelSmall: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: 0.5),

      bodyLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.15),
      bodyMedium: TextStyle(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.w300, letterSpacing: 0.25),
      bodySmall: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0.4),
    ),
  );
}