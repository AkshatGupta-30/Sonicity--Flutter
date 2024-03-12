import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/cloned_database.dart';
import 'package:sonicity/src/database/starred_database.dart';
import 'package:sonicity/src/models/playlist.dart';

class PlaylistController extends GetxController {
  final Playlist playlist;
  PlaylistController(this.playlist);

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
    isClone.value = await cloneDb.isPresent(playlist);
    isStar.value = await starDb.isPresent(playlist);
    update();
  }

  void switchCloned() async {
    (isClone.value) ? cloneDb.deleteClone(playlist) : cloneDb.clone(playlist);
    checkCloneAndStar();
  }

  void switchStarred() async {
    (isStar.value) ? starDb.deleteStarred(playlist) : starDb.starred(playlist);
    checkCloneAndStar();
  }
}