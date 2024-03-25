import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';

class PlayerController extends GetxController {
  final audioManager = getIt<AudioManager>();

  final isFavorite = false.obs;
  final currentSong = Song.empty().obs;

  @override
  void onInit() {
    super.onInit();
    setSong();
    audioManager.currentSongNotifier.addListener(() async => await setSong());
  }

  Future<void> setSong() async {
    MediaItem? currentMediaItem = audioManager.currentSongNotifier.value;
    if(currentMediaItem != null) {
      currentSong.value = await SongDetailsApi.forPlay(currentMediaItem.id);
      isFavorite.value = await getIt<StarredDatabase>().isPresent(currentSong.value);
      update();
    }
  }

  void toggleStarred() async {
    if(!isFavorite.value) {
      await getIt<StarredDatabase>().starred(currentSong.value);
      isFavorite.value = true;
    } else {
      await getIt<StarredDatabase>().deleteStarred(currentSong.value);
      isFavorite.value = false;
    }
  }
}