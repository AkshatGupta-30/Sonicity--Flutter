import 'package:get/get.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/services/album_details_api.dart';

class AlbumDetailController extends GetxController {
  final String albumId;
  AlbumDetailController(this.albumId);

  final album = Album.empty().obs;

  @override
  void onInit() {
    super.onInit();
    getDetails();
  }

  void getDetails() async {
    Album music = await AlbumDetailsApi.get(albumId);
    album.value = music;
  }
}