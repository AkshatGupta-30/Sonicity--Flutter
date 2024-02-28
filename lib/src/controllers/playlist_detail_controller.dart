import 'package:get/get.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/services/playlist_details_api.dart';

class PlaylistDetailController extends GetxController {
  final String playlistId;
  PlaylistDetailController(this.playlistId);

  final playlist = Playlist.empty().obs;

  @override
  void onInit() {
    super.onInit();
    getDetails();
  }

  void getDetails() async {
    Playlist music = await PlaylistDetailsApi.get(playlistId);
    playlist.value = music;
  }
}