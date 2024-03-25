import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';

class ArtistController extends GetxController {
  final Artist artist;
  ArtistController(this.artist);

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
    isClone.value = await cloneDb.isPresent(artist);
    isStar.value = await starDb.isPresent(artist);
    update();
  }

  void switchCloned() async {
    (isClone.value) ? cloneDb.deleteClone(artist) : cloneDb.clone(artist);
    checkCloneAndStar();
  }

  void switchStarred() async {
    (isStar.value) ? starDb.deleteStarred(artist) : starDb.starred(artist);
    checkCloneAndStar();
  }
}