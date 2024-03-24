import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/audio/audio_manager.dart';
import 'package:sonicity/src/audio/my_audio_handler.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/database/cloned_database.dart';
import 'package:sonicity/src/database/home_database.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/database/starred_database.dart';
import 'package:sonicity/src/firebase/database_methods.dart';
import 'package:sonicity/src/firebase/storage_methods.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // * : Database
  getIt.registerSingleton<HomeDatabase>(HomeDatabase());
  getIt.registerSingleton<RecentsDatabase>(RecentsDatabase());
  getIt.registerLazySingleton<MyPlaylistsDatabase>(() => MyPlaylistsDatabase());
  getIt.registerLazySingleton<ClonedDatabase>(() => ClonedDatabase());
  getIt.registerLazySingleton<StarredDatabase>(() => StarredDatabase());

  // * : Audio
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerSingleton<AudioManager>(AudioManager());

  // * : GetX Controllers
  Get.put(SettingsController());
  Get.lazyPut(() => StorageMethods());
  Get.lazyPut(() => DatabaseMethods());
}