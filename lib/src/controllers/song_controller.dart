import 'package:get/get.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class SongController extends GetxController {
  final Song song;
  SongController(this.song);

  final cloneDb = getIt<ClonedDatabase>();
  final starDb = getIt<StarredDatabase>();
  final isClone = false.obs;
  final isStar = false.obs;

  final album = Album.empty().obs;

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