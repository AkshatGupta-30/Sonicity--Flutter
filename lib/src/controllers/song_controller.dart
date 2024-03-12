import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/cloned_database.dart';
import 'package:sonicity/src/models/song.dart';

class SongController extends GetxController {
  final Song song;
  SongController(this.song);

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
    isCloned.value = await db.isPresent(song);
    update();
  }

  void switchCloned() async {
    (isCloned.value) ? db.deleteClone(song) : db.clone(song);
    cloneCheck();
  }
}