import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';

class QueueController extends GetxController {
  final Song song;
  QueueController(this.song);
  
  final showFab = true.obs;

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

  bool onNotification(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    if (direction == ScrollDirection.reverse) showFab.value = false;
    else if (direction == ScrollDirection.forward) showFab.value = true;
    return true;
  }

  void showAllQueueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
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
}