import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/views/navigation_view.dart';
import 'package:sonicity/utils/contants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final settingsController = Get.find<SettingsController>();
  
  @override
  void initState() {
    super.initState();
    getIt<AudioManager>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'Sonicity',
      debugShowCheckedModeBanner: false,
      home: NavigationView(),
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