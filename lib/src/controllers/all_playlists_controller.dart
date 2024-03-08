import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/models/my_playlist.dart';

class AllPlaylistsController extends GetxController {
  final db = GetIt.instance<MyPlaylistsDatabase>();
  final myPlaylists = <MyPlaylist>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMyPlaylists();
  }
  
  Future<void> getMyPlaylists() async {
    myPlaylists.value = await db.playlists;
  }
}