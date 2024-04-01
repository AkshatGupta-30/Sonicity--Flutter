import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/contants/constants.dart';
// import 'package:sonicity/src/services/services.dart';

DateTime playerTapTime = DateTime.now();
bool get isProcessForPlay => DateTime.now().difference(playerTapTime).inMilliseconds > 600;

Timer? debounce;

Future<void> playSong(Song song, {bool isAutoQueue = false}) async {
  List<Song> songs = [song];
  if(isAutoQueue) {
    songs.addAll(await SongSuggestionsApi.fetchData(song.id));
    getIt<QueueDatabase>().autoQueue('Song - ${song.title}', songs);
  }
  debounce?.cancel();
  debounce = Timer(
    const Duration(milliseconds: 600), () {
      PlayerInvoke.init(songsList: songs, index: 0, shuffle: false);
    }
  );
}

void playSongs(List<Song> songs, {required int index, bool shuffle = false}) {
  debounce?.cancel();
  debounce = Timer(
    const Duration(milliseconds: 600), () {
      PlayerInvoke.init(songsList: songs, index: index, shuffle: shuffle);
    }
  );
}

class PlayerInvoke {
  static final audioManager = getIt<AudioManager>();
  
  static Future<void> init({
    required List<Song> songsList,
    required int index,
    required bool shuffle,
    bool fromMiniPlayer = false,
    String? playlistBox,
  }) async {
    final int globalIndex = index < 0 ? 0 : index;
    final List<Song> finalList = songsList.toList();
    if(shuffle) finalList.shuffle();
    setValues(finalList, globalIndex);
  }

  static Future<void> setValues(List<Song> arr, int index, {recommend = false}) async {
    final List<MediaItem> queue = [];
    // ! index == arr.length ? null : arr[index + 1] as Map;
    queue.addAll(arr.map((Song song) => song.toMediaItem(autoplay: recommend)));
    updateNPlay(queue, index);
  }

  static Future<void> updateNPlay(List<MediaItem> queue, int index) async {
    await audioManager.setShuffleMode(AudioServiceShuffleMode.none);
    await audioManager.adds(queue, index);
    await audioManager.playAS();
  }
}