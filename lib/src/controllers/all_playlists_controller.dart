import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/playlist.dart';

class AllPlaylistsController extends GetxController {
  final db = GetIt.instance<MyPlaylistsDatabase>();
  final myPlaylists = <Playlist>[].obs;
  final dateCreated = <String>[].obs;
  final coverImages = <ImageUrl>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMyPlaylists();
  }
  
  Future<void> getMyPlaylists() async {
    List<Playlist> p =[];
    List<String> d = [];
    List<ImageUrl> c = [];
    (p, d, c) = await db.playlists;

    myPlaylists.value = p;
    dateCreated.value = d;
    coverImages.value = c;
  }
}