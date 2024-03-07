import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/database/home_database.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/firebase/database_methods.dart';
import 'package:sonicity/src/firebase/storage_methods.dart';
import 'package:sonicity/src/views/navigation_view.dart';
import 'package:sonicity/utils/contants/themes.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // * : Database
  GetIt.I.registerLazySingleton<HomeDatabase>(() => HomeDatabase());
  GetIt.I.registerLazySingleton<MyPlaylistsDatabase>(() => MyPlaylistsDatabase());
  GetIt.I.registerLazySingleton<RecentsDatabase>(() => RecentsDatabase());

  // * : GetX Controllers
  Get.put(SettingsController());
  Get.lazyPut(() => StorageMethods());
  Get.lazyPut(() => DatabaseMethods());

  _downloadAllDatabase();

  runApp(MainApp());
}

Future<void> _downloadAllDatabase() async {
    try {
      Directory app = await getApplicationDocumentsDirectory();
      String path = "${app.path}my_playlists.db";
      String databasePath = path;
      String databaseFile = '/storage/emulated/0/Databases/my_playlists.db';
      await File(databasePath).copy(databaseFile);
      ('Database downloaded to: $databaseFile').printInfo();
    } catch (e) {
      ('Error downloading database: $e').printError();
    }
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
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
      ),
    ));
  }
}