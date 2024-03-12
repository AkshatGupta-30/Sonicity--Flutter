import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/cloned_database.dart';
import 'package:sonicity/src/database/starred_database.dart';
import 'package:sonicity/src/models/song.dart';

class SongController extends GetxController {
  final Song song;
  SongController(this.song);

  final cloneDb = GetIt.instance<ClonedDatabase>();
  final starDb = GetIt.instance<StarredDatabase>();
  final isClone = false.obs;
  final isStar = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkCloneAndStar();
  }
  @override
  void onReady() {
    super.onReady();
    checkCloneAndStar();
  }

  void checkCloneAndStar() async {
    isClone.value = await cloneDb.isPresent(song);
    isStar.value = await starDb.isPresent(song);
    update();
  }

  void switchCloned() async {
    (isClone.value) ? cloneDb.deleteClone(song) : cloneDb.clone(song);
    checkCloneAndStar();
  }

  void switchStarred() async {
    (isStar.value) ? starDb.deleteStarred(song) : starDb.starred(song);
    checkCloneAndStar();
  }
}