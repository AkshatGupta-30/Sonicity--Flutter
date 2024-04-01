import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class QueueDetailController extends GetxController {
  final showFab = true.obs;
  final db = getIt<QueueDatabase>();
  final audioManager = getIt<AudioManager>();

  final queues = <Queue>[].obs;
  final selectedQueue = Queue.empty().obs;
  final playingQueue = Queue.empty().obs;
  final currentSongIndex = 0.obs;

  final renameQueueTextController = TextEditingController();
  FocusNode renameQueueFocus = FocusNode();
  final renameQueueTfActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAll();
    audioManager.currentSongNotifier.addListener(() {
      if(audioManager.currentSongNotifier.value == null) {
        db.updatePlayingQueue(playingQueue.value.name, isPlaying: false).then((value) => getAll());
      }
    });
  }

  Future<void> getAll() async {
    queues.value = await db.queues;
    if(queues.isNotEmpty) setSelectedQueue(queues.singleWhere((queue) => queue.isCurrent));
    if(queues.isNotEmpty) {
      try {
        playingQueue.value = (queues.singleWhere((queue) => queue.isPlaying));
      } catch (e) {
        playingQueue.value = Queue.empty();
      }
    }
  }

  void setSelectedQueue(Queue q) async {
    queues.firstWhere((queue) => queue.isCurrent).isCurrent = false;
    selectedQueue.value = q;
    selectedQueue.value.isCurrent = true;
    selectedQueue.value.songs = await db.getSongs(selectedQueue.value.name);
    update();
    db.updateSelectedQueue(q.name);
  }

  void deleteQueue(Queue q) async => await db.deleteQueue(q.name).then((value) async => await getAll());

  void renameQueue(Queue q) => db.renameQueue(q.name, renameQueueTextController.text).then((value) => getAll());

  bool onNotification(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    if (direction == ScrollDirection.reverse) showFab.value = false;
    else if (direction == ScrollDirection.forward) showFab.value = true;
    return true;
  }

  String formatDuration(List<Song> songs, {bool short = false}) {
    int seconds = 0;
    for (Song song in songs) seconds += int.parse(song.duration.toString());
    Duration duration = Duration(seconds: seconds);

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int remainingSeconds = duration.inSeconds.remainder(60);

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = remainingSeconds.toString().padLeft(2, '0');

    if(short) {
      if(minutesString == '00' && hoursString == '00') return secondsString;
      else if(hoursString == '00') return '$minutesString:$secondsString';
    }

    return '$hoursString:$minutesString:$secondsString';
  }

  void sort(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? selectedQueue.value.songs!.sort((a, b) => a.name.compareTo(b.name))
        : selectedQueue.value.songs!.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? selectedQueue.value.songs!.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : selectedQueue.value.songs!.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? selectedQueue.value.songs!.sort((a, b) => a.year!.compareTo(b.year!))
        : selectedQueue.value.songs!.sort((a, b) => b.year!.compareTo(a.year!));
    }
    db.reorderSongs(selectedQueue.value.name, selectedQueue.value.songs!);
    update();
  }

  void onReorderQueues(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    Queue swappingQueue = queues.removeAt(oldIndex);
    queues.insert(newIndex, swappingQueue);
    db.reorderQueueRows(queues);
  }

  void onReorderSongs(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    Song orderingSong = selectedQueue.value.songs!.removeAt(oldIndex);
    selectedQueue.value.songs!.insert(newIndex, orderingSong);
    db.reorderSongs(selectedQueue.value.name, selectedQueue.value.songs!);
  }

  void setCurrentIndex(MediaItem? currentSong) {
    if(currentSong == null) {
      currentSongIndex.value = 0;
      return;
    }
    currentSongIndex.value = selectedQueue.value.songs!.indexWhere((song) => (currentSong.id == song.id)) + 1;
  }

  void removeSong(Song song) {
    selectedQueue.value.songs!.remove(song);
    db.deleteSong(selectedQueue.value.name, song);
  }
}