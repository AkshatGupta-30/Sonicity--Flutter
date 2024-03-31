import 'package:get/get.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class PlaylistController extends GetxController {
  final Playlist playlist;
  PlaylistController(this.playlist);

  final cloneDb = getIt<ClonedDatabase>();
  final starDb = getIt<StarredDatabase>();
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