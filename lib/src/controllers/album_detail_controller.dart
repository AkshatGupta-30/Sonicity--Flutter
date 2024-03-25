import 'package:get/get.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/contants/constants.dart';

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

  void sort(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? album.value.songs!.sort((a, b) => a.name.compareTo(b.name))
        : album.value.songs!.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? album.value.songs!.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : album.value.songs!.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? album.value.songs!.sort((a, b) => a.year!.compareTo(b.year!))
        : album.value.songs!.sort((a, b) => b.year!.compareTo(a.year!));
    }
    update();
  }
}