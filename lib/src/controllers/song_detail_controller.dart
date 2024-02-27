import 'package:get/get.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/song_details_api.dart';

class SongDetailController extends GetxController {
  final String songId;
  SongDetailController(this.songId);

  final song = Song.empty().obs;

  @override
  void onInit() {
    super.onInit();
    getDetails();
  }

  void getDetails() async {
    Song music = await SongDetailsApi.get(songId);
    song.value = music;
  }
}