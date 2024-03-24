import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:sonicity/src/audio/audio_manager.dart';
import 'package:sonicity/src/audio/mediaitem_converter.dart';
import 'package:sonicity/src/audio/service_locator.dart';
import 'package:sonicity/src/models/song.dart';

DateTime playerTapTime = DateTime.now();
bool get isProcessForPlay {
  return DateTime.now().difference(playerTapTime).inMilliseconds > 600;
}

Timer? debounce;

void playerPlayProcessDebounce({required List<Song> songs, required int index}) {
  debounce?.cancel();
  debounce = Timer(const Duration(milliseconds: 600), () {
      PlayerInvoke.init(songsList: songs, index: index,);
  });
}

class PlayerInvoke {
  static final audioManager = getIt<AudioManager>();

  static Future<void> init({
    required List<Song> songsList,
    required int index,
    bool fromMiniPlayer = false,
    bool shuffle = false,
    String? playlistBox,
  }) async {
    final int globalIndex = index < 0 ? 0 : index;
    final List<Song> finalList = songsList.toList();
    if (shuffle) finalList.shuffle();

    if (!fromMiniPlayer) {
      if (!Platform.isAndroid) await audioManager.stop();
      setValues(finalList, globalIndex);
    }
  }

  static Future<void> setValues(List<Song> arr, int index, {recommend = false}) async {
    final List<MediaItem> queue = [];
    // ! index == arr.length ? null : arr[index + 1] as Map;
    queue.addAll(arr.map((Song song) => MediaItemConverter.toMediaItem(song, autoplay: recommend)));
    updateNPlay(queue, index);
  }

  static Future<void> updateNPlay(List<MediaItem> queue, int index) async {
    try {
      await audioManager.setShuffleMode(AudioServiceShuffleMode.none);
      await audioManager.adds(queue, index);
      await audioManager.playAS();  
    } catch (e) {

      print("error: $e");
      
    }
  }
}