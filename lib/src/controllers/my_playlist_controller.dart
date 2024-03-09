import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';

class  MyPlaylistController extends GetxController {
  final db = GetIt.instance<MyPlaylistsDatabase>();
  final playlists = [].obs;

  @override
  void onInit() {
    super.onInit();
    getPlaylists();
  }

  Future<void> getPlaylists() async => playlists.value = await db.playlists;
}