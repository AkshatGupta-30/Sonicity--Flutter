// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/src/controllers/navigation_controller.dart';
import 'package:sonicity/src/firebase/database_methods.dart';
import 'package:sonicity/src/firebase/storage_methods.dart';
import 'package:sonicity/src/views/navigation_view.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/contants/fonts.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';

Future<void> main() async {
  // GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(StorageMethods());
  Get.put(DatabaseMethods());
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var drawerThemeData = DrawerThemeData(
            scrimColor: Colors.black45,
            backgroundColor: Colors.transparent,
            elevation: 2,
            shadowColor: Colors.white60,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.sizeOf(context).width/1.25,
          );
    var listTileThemeData = ListTileThemeData(
            dense: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: Fonts.lovelyMamma),
            subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: Fonts.lovelyMamma),
          );
    var popupMenuThemeData = PopupMenuThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            position: PopupMenuPosition.under,
            color: Colors.grey.shade900,
            labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade100, fontSize: 18, fontFamily: Fonts.lovelyMamma)),
          );
    var tabBarTheme = TabBarTheme(
            indicatorColor: Colors.red,
            dividerColor: Colors.red.withOpacity(0.5),
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            labelColor: accentColor, labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
            unselectedLabelColor: accentColorDark, unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: Fonts.lovelyMamma),
          );
    var tooltipThemeData = TooltipThemeData(
            preferBelow: false,
            waitDuration: Duration(milliseconds: 500),
            showDuration: Duration(seconds: 2),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(5),
            ),
          );
    return BetterFeedback(
      mode: FeedbackMode.draw, themeMode: ThemeMode.system,
      feedbackBuilder: (BuildContext context, OnSubmit onSubmit, ScrollController? scrollController) {
        final textController = TextEditingController();
        return ReportSheet(
          textController: textController,
          scrollController: scrollController,
          onSubmit: onSubmit
        );
      },
      darkTheme: FeedbackThemeData.dark(),
      child: GetMaterialApp(
        // themeMode: ThemeMode.dark,
        title: 'Sonicity',
        debugShowCheckedModeBanner: false,
        home: NavigationView(),
        theme: ThemeData(
          fontFamily: Fonts.lovelyMamma,
          bottomNavigationBarTheme: bottomNavBarThemeData,
          scaffoldBackgroundColor: Colors.black,
          actionIconTheme: actionIconThemeData,
          appBarTheme: appBarThemeData,
          elevatedButtonTheme: elevatedButtonThemeData,
          dividerTheme: dividerThemeData,
          drawerTheme: drawerThemeData,
          listTileTheme: listTileThemeData,
          popupMenuTheme: popupMenuThemeData,
          tabBarTheme: tabBarTheme,
          useMaterial3: true,
          tooltipTheme: tooltipThemeData
        ),
      ),
    );
  }
}

final dividerThemeData = DividerThemeData(
  color: Colors.white12,
  thickness: 1, space: 1
);

final elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.transparent),
    shadowColor: MaterialStatePropertyAll(Colors.transparent),
    surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
    overlayColor: MaterialStatePropertyAll(Colors.grey.shade900),
    padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10)),
    splashFactory: InkRipple.splashFactory
  ),
);

final appBarThemeData = AppBarTheme(
  elevation: 2, toolbarHeight: kToolbarHeight,
  backgroundColor: Colors.grey.shade900,
  shadowColor: Colors.white,
  surfaceTintColor: Colors.grey.shade900,
  centerTitle: true,
  foregroundColor: Colors.white,
  titleTextStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: Fonts.lovelyMamma),
  actionsIconTheme: IconThemeData(color: Colors.grey.shade200),
);

final actionIconThemeData = ActionIconThemeData(
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

final bottomNavBarThemeData = BottomNavigationBarThemeData(
  elevation: 2,
  backgroundColor: Colors.black,
  selectedItemColor: accentColor,
  unselectedItemColor: Colors.white,
  selectedIconTheme: IconThemeData(color: accentColor, size: 30),
  unselectedIconTheme: IconThemeData(color: Colors.white, size: 30),
  showSelectedLabels: true, showUnselectedLabels: true,
  type: BottomNavigationBarType.fixed,
  selectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
  unselectedLabelStyle: TextStyle(fontFamily: Fonts.lovelyMamma, fontSize: 18),
);