// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/src/views/navigation_view.dart';

Future<void> main() async {
  // GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      darkTheme: FeedbackThemeData.dark(),
      child: GetMaterialApp(
        themeMode: ThemeMode.dark,
        title: 'Sonicity',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "LovelyMamma",
          scaffoldBackgroundColor: Colors.black,
        ),
        home: NavigationView(),
      ),
    );
  }
}
