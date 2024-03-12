import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/cloned_database.dart';
import 'package:sonicity/src/models/artist.dart';

class ArtistController extends GetxController {
  final Artist artist;
  ArtistController(this.artist);

  final db = GetIt.instance<ClonedDatabase>();
  final isCloned = false.obs;

  @override
  void onInit() {
    super.onInit();
    cloneCheck();
  }
  @override
  void onReady() {
    super.onReady();
    cloneCheck();
  }

  void cloneCheck() async {
    isCloned.value = await db.isPresent(artist);
    update();
  }

  void switchCloned() async {
    (isCloned.value) ? db.deleteClone(artist) : db.clone(artist);
    cloneCheck();
  }
}