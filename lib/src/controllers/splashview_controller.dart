import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/views/navigation_view.dart';

class SplashViewController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;
  
  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    initSetup();
  }
  
  void initSetup() async {
    await setupServiceLocator();
    Future.delayed(Duration(milliseconds: 2500), () async => Get.off(() => NavigationView()));
  }

  Future<void> setupServiceLocator() async {
    // * : Database
    getIt.registerSingleton<HomeDatabase>(HomeDatabase());
    getIt.registerSingleton<RecentsDatabase>(RecentsDatabase());
    getIt.registerSingleton<QueueDatabase>(QueueDatabase());
    getIt.registerLazySingleton<MyPlaylistsDatabase>(() => MyPlaylistsDatabase());
    getIt.registerLazySingleton<ClonedDatabase>(() => ClonedDatabase());
    getIt.registerLazySingleton<StarredDatabase>(() => StarredDatabase());

    // * : Audio
    getIt.registerSingleton<AudioHandler>(await initAudioService());
    getIt.registerLazySingleton<AudioManager>(() => AudioManager());

    // * : GetX Controllers
    Get.lazyPut(() => PlayerController());
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    _controller.dispose();
    super.onClose();
  }
}