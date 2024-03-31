import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/views/splash_view.dart';
import 'package:sonicity/utils/contants/constants.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'Sonicity',
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      themeMode: settingsController.getThemeMode,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
    ));
  }

  @override
  void dispose() {
    getIt<AudioManager>().dispose();
    super.dispose();
  }
}