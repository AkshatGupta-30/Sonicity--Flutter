import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';

class SongDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  final String songId;
  SongDetailController(this.songId);

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
      lyrics.value.lyrics = _addNewlines(lyrics.value.lyrics);
    }
  }

  String _addNewlines(String input) {
    List<String> words = input.split(' ');

    for (int i = 0; i < words.length - 1; i++) {
      // Check if current word starts with a capital letter
      bool currentStartsWithCapital = words[i].isNotEmpty && words[i][0] == words[i][0].toUpperCase();
      
      // Check if next word exists and does not start with a capital letter
      bool nextDoesNotStartWithCapital = (i + 1 < words.length) && 
                                          (words[i + 1].isEmpty || words[i + 1][0] != words[i + 1][0].toUpperCase());

      // If conditions are met, insert a newline before the current word
      if (currentStartsWithCapital && nextDoesNotStartWithCapital) {
        words[i] = '\n${words[i]}';
      }
    }

    return words.join(' ');
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}