import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/cloned_database.dart';
import 'package:sonicity/src/models/playlist.dart';

class PlaylistController extends GetxController {
  final Playlist playlist;
  PlaylistController(this.playlist);

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
    isCloned.value = await db.isPresent(playlist);
    update();
  }

  void switchCloned() async {
    (isCloned.value) ? db.deleteClone(playlist) : db.clone(playlist);
    cloneCheck();
  }
}