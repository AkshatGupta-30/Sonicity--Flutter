import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/artist_song_album.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/src/services/artist_details_api.dart';

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
  final albumCat = Category.latest.obs;
  final albumSort = Sort.desc.obs;
  final albumsIsLoading = false.obs;
  final albumCount = 0.obs;

  final songList = <Song>[].obs;
  int songPage = 1;
  final songCat = Category.latest.obs;
  final songSort = Sort.desc.obs;
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
    List<Album> listAl = await ArtistDetailsApi.getAlbums(albumId, page, albumCat.value, albumSort.value);
    albumList.addAll(listAl);
  }

  Future<void> getArtistSongs(int page) async {
    List<Song> listSo = await ArtistDetailsApi.getSongs(albumId, page, songCat.value, songSort.value);
    songList.addAll(listSo);
  }

  void fetchCount() async {
    int alCount = await ArtistDetailsApi.getAlbumCount(albumId);
    albumCount.value = alCount;

    int soCount = await ArtistDetailsApi.getSongCount(albumId);
    songCount.value = soCount;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}