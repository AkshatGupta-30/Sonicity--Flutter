import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';

class AlbumController extends GetxController {
  final Album album;
  AlbumController(this.album);

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
    isClone.value = await cloneDb.isPresent(album);
    isStar.value = await starDb.isPresent(album);
    update();
  }

  void switchCloned() async {
    (isClone.value) ? cloneDb.deleteClone(album) : cloneDb.clone(album);
    checkCloneAndStar();
  }

  void switchStarred() async {
    (isStar.value) ? starDb.deleteStarred(album) : starDb.starred(album);
    checkCloneAndStar();
  }
}