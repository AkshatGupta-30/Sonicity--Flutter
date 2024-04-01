import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/views/splash_view.dart';
import 'package:sonicity/utils/contants/constants.dart';

void main() {
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
      themeMode: settingsController.getThemeMode,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: SplashView(),
      onDispose: () {
        getIt<AudioManager>().dispose();
        getIt<HomeDatabase>().dispose();
        getIt<RecentsDatabase>().dispose();
        getIt<QueueDatabase>().dispose();
        getIt<MyPlaylistsDatabase>().dispose();
        getIt<ClonedDatabase>().dispose();
        getIt<StarredDatabase>().dispose();
      },
    ));
  }
}