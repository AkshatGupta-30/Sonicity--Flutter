import 'package:get/get.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:sonicity/src/services/new_song_details_api.dart';

class SongDetailController extends GetxController {
  final String songId;
  SongDetailController(this.songId);

  final song = NewSong.empty().obs;

  @override
  void onInit() {
    super.onInit();
    getDetails();
  }

  void getDetails() async {
    NewSong music = await NewSongDetailsApi.get(songId);
    song.value = music;
  }
}