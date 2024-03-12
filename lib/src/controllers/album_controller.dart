import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/cloned_database.dart';
import 'package:sonicity/src/models/album.dart';

class AlbumController extends GetxController {
  final Album album;
  AlbumController(this.album);

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
    isCloned.value = await db.isPresent(album);
    update();
  }

  void switchCloned() async {
    (isCloned.value) ? db.deleteClone(album) : db.clone(album);
    cloneCheck();
  }
}