// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/src/controllers/navigation_controller.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/utils/contants/fonts.dart';

class Themes extends GetxController {
  final theme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    fontFamily: Fonts.lovelyMamma,
    bottomNavigationBarTheme: MyTheme.bottomNavBarThemeData,
    actionIconTheme: MyTheme.actionIconThemeData,
    appBarTheme: MyTheme.appBarThemeData,
    elevatedButtonTheme: MyTheme.elevatedButtonThemeData,
    dividerTheme: MyTheme.dividerThemeData,
    drawerTheme: MyTheme.drawerThemeData,
    listTileTheme: MyTheme.listTileThemeData,
    popupMenuTheme: MyTheme.popupMenuThemeData,
    tabBarTheme: MyTheme.tabBarTheme,
    tooltipTheme: MyTheme.tooltipThemeData
  ).obs;
}

class MyTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    fontFamily: Fonts.lovelyMamma,
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
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
      actionsIconTheme: IconThemeData(color: Colors.grey.shade200),
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: Colors.red,
      dividerColor: Colors.red.withOpacity(0.5),
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      labelColor: Get.find<SettingsController>().getAccent, labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
      unselectedLabelColor: Get.find<SettingsController>().getAccentDark, unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: Fonts.lovelyMamma),
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
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: Fonts.lovelyMamma),
      subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: Fonts.lovelyMamma),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      color: Colors.grey.shade900,
      labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade100, fontSize: 18, fontFamily: Fonts.lovelyMamma)),
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
      selectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
      unselectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: Fonts.lovelyMamma,
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
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
      actionsIconTheme: IconThemeData(color: Colors.grey.shade200),
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: Colors.red,
      dividerColor: Colors.red.withOpacity(0.5),
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      labelColor: Get.find<SettingsController>().getAccent, labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
      unselectedLabelColor: Get.find<SettingsController>().getAccentDark, unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: Fonts.lovelyMamma),
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
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: Fonts.lovelyMamma),
      subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: Fonts.lovelyMamma),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      color: Colors.grey.shade900,
      labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade100, fontSize: 18, fontFamily: Fonts.lovelyMamma)),
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
      selectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
      unselectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
    ),
  );

  static final drawerThemeData = DrawerThemeData(
    scrimColor: Colors.black45,
    backgroundColor: Colors.transparent,
    elevation: 2,
    shadowColor: Colors.white60,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    width: 300,
  );

  static final listTileThemeData = ListTileThemeData(
    dense: false,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: Fonts.lovelyMamma),
    subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: Fonts.lovelyMamma),
  );

  static final popupMenuThemeData = PopupMenuThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    position: PopupMenuPosition.under,
    color: Colors.grey.shade900,
    labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade100, fontSize: 18, fontFamily: Fonts.lovelyMamma)),
  );

  static final tabBarTheme = TabBarTheme(
    indicatorColor: Colors.red,
    dividerColor: Colors.red.withOpacity(0.5),
    overlayColor: MaterialStatePropertyAll(Colors.transparent),
    splashFactory: NoSplash.splashFactory,
    labelColor: Get.find<SettingsController>().getAccent, labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
    unselectedLabelColor: Get.find<SettingsController>().getAccentDark, unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: Fonts.lovelyMamma),
  );

  static final tooltipThemeData = TooltipThemeData(
    preferBelow: false,
    waitDuration: Duration(milliseconds: 500),
    showDuration: Duration(seconds: 2),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: BorderRadius.circular(5),
    ),
  );

  static final dividerThemeData = DividerThemeData(
    color: Colors.white12,
    thickness: 1, space: 1
  );

  static final elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.transparent),
      shadowColor: MaterialStatePropertyAll(Colors.transparent),
      surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
      overlayColor: MaterialStatePropertyAll(Colors.grey.shade900),
      padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10)),
      splashFactory: InkRipple.splashFactory
    ),
  );

  static final appBarThemeData = AppBarTheme(
    elevation: 2, toolbarHeight: kToolbarHeight,
    backgroundColor: Colors.grey.shade900,
    shadowColor: Colors.white,
    surfaceTintColor: Colors.grey.shade900,
    centerTitle: true,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
    actionsIconTheme: IconThemeData(color: Colors.grey.shade200),
  );

  static final actionIconThemeData = ActionIconThemeData(
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
  );

  static final bottomNavBarThemeData = BottomNavigationBarThemeData(
    elevation: 2,
    backgroundColor: Colors.black,
    selectedItemColor: Get.find<SettingsController>().getAccent,
    unselectedItemColor: Colors.white,
    selectedIconTheme: IconThemeData(color: Get.find<SettingsController>().getAccent, size: 30),
    unselectedIconTheme: IconThemeData(color: Colors.white, size: 30),
    showSelectedLabels: true, showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
    unselectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
  );
}