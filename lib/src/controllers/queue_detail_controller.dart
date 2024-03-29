import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class QueueDetailController extends GetxController {
  final showFab = true.obs;
  final db = getIt<QueueDatabase>();

  final queues = <Queue>[].obs;
  final selectedQueue = Queue.empty().obs;
  final currentSongIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAll();
  }

  Future<void> getAll() async {
    queues.value = await db.queues;
    setSelectedQueue(queues.singleWhere((queue) => queue.isCurrent));
  }

  void setSelectedQueue(Queue q) async {
    queues.firstWhere((element) => element.isCurrent).isCurrent = false;
    selectedQueue.value = q;
    selectedQueue.value.isCurrent = true;
    selectedQueue.value.songs = await db.getSongs(selectedQueue.value.name);
    update();
    db.updateSelectedQueue(q.name);
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
    update();
  }

  bool onNotification(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    if (direction == ScrollDirection.reverse) showFab.value = false;
    else if (direction == ScrollDirection.forward) showFab.value = true;
    return true;
  }

  String formatDuration(List<Song> songs) {
    int seconds = 0;
    for (Song song in songs) seconds += int.parse(song.duration.toString());
    Duration duration = Duration(seconds: seconds);

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int remainingSeconds = duration.inSeconds.remainder(60);

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = remainingSeconds.toString().padLeft(2, '0');

    if(minutesString == '00' && hoursString == '00') return secondsString;
    else if(hoursString == '00') return '$minutesString:$secondsString';

    return '$hoursString:$minutesString:$secondsString';
  }
}