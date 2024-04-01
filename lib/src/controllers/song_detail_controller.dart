import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';

class SongDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  final String songId;
  SongDetailController(this.songId);

  final showFab = true.obs;
  final song = Song.empty().obs;
  final lyrics = Lyrics.empty().obs;
  late TabController tabController;
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
      update();
    });
    getDetails();
  }

  void getDetails() async {
    Song music = await SongDetailsApi.get(songId);
    song.value = music;
    lyrics.value = await LyricsApi.fetch(song.value);
    if(lyrics.value.isNotEmpty()) {
      lyrics.value.lyrics = lyrics.value.lyrics;
    }
  }

  bool onNotification(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    if (direction == ScrollDirection.reverse) showFab.value = false;
    else if (direction == ScrollDirection.forward) showFab.value = true;
    return true;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}