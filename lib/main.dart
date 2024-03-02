// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/src/firebase/database_methods.dart';
import 'package:sonicity/src/firebase/storage_methods.dart';
import 'package:sonicity/src/views/navigation_view.dart';
import 'package:sonicity/utils/contants/colors.dart';
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
        themeMode: ThemeMode.dark,
        title: 'Sonicity',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: NavigationView(),
      ),
    );
  }
}

final themeData = ThemeData(
  bottomNavigationBarTheme: bottomNavBarThemeData,
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
  selectedLabelStyle: TextStyle(fontFamily: 'LovelyMamma', fontSize: 18),
  unselectedLabelStyle: TextStyle(fontFamily: 'LovelyMamma', fontSize: 18),
);