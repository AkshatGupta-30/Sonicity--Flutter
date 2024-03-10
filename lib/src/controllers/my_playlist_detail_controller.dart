import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:sonicity/utils/contants/enums.dart';

class MyPlaylistDetailController extends GetxController {
  final MyPlaylist importedPlaylist;
  MyPlaylistDetailController(this.importedPlaylist);

  final playlist = MyPlaylist.empty().obs;
  final db = GetIt.instance<MyPlaylistsDatabase>();

  @override
  void onInit() {
    super.onInit();
    playlist.value = importedPlaylist;
    getSongs();
  }

  void getSongs() async {
    playlist.value.songs = await db.getSongs(importedPlaylist.name);
    update();
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