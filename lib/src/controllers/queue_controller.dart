import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';

class QueueController extends GetxController {
  final Song song;
  QueueController(this.song);

  final db = getIt<QueueDatabase>();
  SettingsController settings = Get.find<SettingsController>();
  final queues = <Queue>[].obs;
  final isSongPresent = <bool>[].obs;
  final queueCount = (2).obs;

  final searching = false.obs;
  final searchResults = <Queue>[].obs;
  final searchIsSongPresent = <bool>[].obs;
  final searchQueueController = TextEditingController();
  FocusNode searchQueueFocus = FocusNode();

  final newQueueTextController = TextEditingController();
  FocusNode newQueueFocus = FocusNode();
  final newQueueTfActive = false.obs;

  @override
  void onInit () {
    super.onInit();
    initMethods();
  }

  Future<void> initMethods() async {
    await getQueueCount();
    await checkSongPresent();
    await getQueues();
  }

  Future<void> getQueues() async => queues.value = await db.queues;
  
  Future<void> getQueueCount() async => queueCount.value= await db.queueCount;
  
  Future<void> checkSongPresent() async => isSongPresent.value = await db.isSongPresent(song);

  void insertSong(String queueName) async => await db.insertSong(queueName, song).then((value) => initMethods());

  void deleteSong(String queueName) async => await db.deleteSong(queueName, song).then((value) => initMethods());

  void createQueue() async {
    if(newQueueTextController.text.isEmpty) return;
    await db.createQueue(newQueueTextController.text).then((value) => initMethods());
  }

  void onReorder(int oldIndex, int newIndex) {
    final reorderedQueue = queues.removeAt(oldIndex);
    queues.insert(newIndex, reorderedQueue);
    db.reorderQueueRows(queues);
  }
}