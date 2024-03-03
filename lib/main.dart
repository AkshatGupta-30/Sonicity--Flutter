// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:get/get.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/firebase/database_methods.dart';
import 'package:sonicity/src/firebase/storage_methods.dart';
import 'package:sonicity/src/views/navigation_view.dart';
import 'package:sonicity/utils/contants/themes.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';

Future<void> main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(SettingsController());
  Get.put(StorageMethods());
  Get.put(DatabaseMethods());
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final settingsController = Get.find<SettingsController>();

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
      child: Obx(() => GetMaterialApp(
          title: 'Sonicity',
          debugShowCheckedModeBanner: false,
          home: NavigationView(),
          themeMode: settingsController.getThemeMode,
          // themeMode: ThemeMode.dark,
          // themeMode: ThemeMode.light,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
        ),
    ));
  }
}