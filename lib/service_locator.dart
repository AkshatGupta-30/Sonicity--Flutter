import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/firebase/firebase.dart';

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
  getIt.registerLazySingleton<AudioManager>(() => AudioManager());

  // * : GetX Controllers
  Get.put(SettingsController());
  Get.lazyPut(() => StorageMethods());
  Get.lazyPut(() => DatabaseMethods());
  Get.lazyPut(() => PlayerController());
}