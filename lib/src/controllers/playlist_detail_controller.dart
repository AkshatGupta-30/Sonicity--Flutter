import 'package:get/get.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/services/playlist_details_api.dart';
import 'package:sonicity/utils/contants/enums.dart';

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

  void sort(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? playlist.value.songs!.sort((a, b) => a.name.compareTo(b.name))
        : playlist.value.songs!.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? playlist.value.songs!.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : playlist.value.songs!.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? playlist.value.songs!.sort((a, b) => a.year!.compareTo(b.year!))
        : playlist.value.songs!.sort((a, b) => b.year!.compareTo(a.year!));
    }
    update();
  }
}