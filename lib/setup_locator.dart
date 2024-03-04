import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/firebase/database_methods.dart';
import 'package:sonicity/src/firebase/storage_methods.dart';

void setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // (await SharedPreferences.getInstance()).clear();
  await GetIt.I.reset();
  Directory appDir = await getApplicationDocumentsDirectory();
  List<FileSystemEntity> files = appDir.listSync();
  for (FileSystemEntity file in files) {
    if (file is File) {
      await file.delete();
    } else if (file is Directory) {
      await file.delete(recursive: true);
    }
  }

  // * : Database
  GetIt.I.registerSingleton<RecentsDatabase>(RecentsDatabase());
  
  // * : GetX Controllers
  Get.put(SettingsController());
  Get.put(StorageMethods());
  Get.put(DatabaseMethods());
}