import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/enums.dart';

class RecentsController extends GetxController {
  final _recentDatabase = GetIt.instance<RecentsDatabase>();
  final recentSongs = <Song>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getSongs();
  }

  void _getSongs() async {
    recentSongs.value = await _recentDatabase.getAll();
  }

  void sortSongs(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => a.name.compareTo(b.name))
        : recentSongs.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : recentSongs.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => a.year!.compareTo(b.year!))
        : recentSongs.sort((a, b) => b.year!.compareTo(a.year!));
    }
    update();
  }
}