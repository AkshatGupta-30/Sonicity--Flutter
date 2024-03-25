import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/services/services.dart';
import 'package:sonicity/utils/contants/constants.dart';

class ArtistDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  final String albumId;
  ArtistDetailController(this.albumId);

  final artist = Artist.empty().obs;
  late TabController tabController;
  final selectedTab = 0.obs;

  final scrollController = ScrollController();
  final innerBoxScrolled = false.obs;

  final albumList = <Album>[].obs;
  int albumPage = 1;
  final albumsIsLoading = false.obs;
  final albumCount = 0.obs;

  final songList = <Song>[].obs;
  int songPage = 1;
  final songsIsLoading = false.obs;
  final songCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
      update();
    });
    getArtistInfo();
    getArtistAlbums(albumPage);
    getArtistSongs(songPage);
    fetchCount();
    scrollController.addListener(_loadMore);
  }

  Future<void> _loadMore() async {
    if(selectedTab.value == 0) {
      if(songsIsLoading.value) return;
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        songsIsLoading.value = true;
        songPage++;
        await getArtistSongs(songPage).then((value) => songsIsLoading.value = false);
      }
    } else if(selectedTab.value == 1) {
      if(albumsIsLoading.value) return;
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        albumsIsLoading.value = true;
        albumPage++;
        await getArtistAlbums(albumPage).then((value) => albumsIsLoading.value = false);
      }
    }
    update();
  }

  void getArtistInfo() async {
    Artist artistInfo = await ArtistDetailsApi.get(albumId);
    artist.value = artistInfo;
  }

  Future<void> getArtistAlbums(int page) async {
    List<Album> listAl = await ArtistDetailsApi.getAlbums(albumId, page);
    albumList.addAll(listAl);
  }

  Future<void> getArtistSongs(int page) async {
    List<Song> listSo = await ArtistDetailsApi.getSongs(albumId, page);
    songList.addAll(listSo);
  }

  void fetchCount() async {
    int alCount = await ArtistDetailsApi.getAlbumCount(albumId);
    albumCount.value = alCount;

    int soCount = await ArtistDetailsApi.getSongCount(albumId);
    songCount.value = soCount;
  }

  void sort(SortType sortType, Sort sortBy, {bool songs = true}) {
    if (songs) {
      if(sortType == SortType.name) {
        (sortBy == Sort.asc)
          ? songList.sort((a, b) => a.name.compareTo(b.name))
          : songList.sort((a, b) => b.name.compareTo(a.name));
      } else if(sortType == SortType.duration) {
        (sortBy == Sort.asc)
          ? songList.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
          : songList.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
      } else {
        (sortBy == Sort.asc)
          ? songList.sort((a, b) => a.year!.compareTo(b.year!))
          : songList.sort((a, b) => b.year!.compareTo(a.year!));
      }
    } else {
      if(sortType == SortType.name) {
        (sortBy == Sort.asc)
          ? albumList.sort((a, b) => a.name.compareTo(b.name))
          : albumList.sort((a, b) => b.name.compareTo(a.name));
      } else if(sortType == SortType.songCount) {
        (sortBy == Sort.asc)
          ? albumList.sort((a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!)))
          : albumList.sort((a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!)));
      } else {
        (sortBy == Sort.asc)
          ? albumList.sort((a, b) => a.year!.compareTo(b.year!))
          : albumList.sort((a, b) => b.year!.compareTo(a.year!));
      }
    }
    update();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}