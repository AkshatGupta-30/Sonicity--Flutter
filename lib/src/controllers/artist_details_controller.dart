import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist_song_album.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:sonicity/src/services/new_artist_details_api.dart';

class ArtistDetailsController extends GetxController {
  final NewAlbum album;
  ArtistDetailsController(this.album);

  final artistSongAlbum = NewArtistSongAlbum.empty().obs;

  final scrollAlbumCont = ScrollController();
  final scrollSongCont = ScrollController();
  final category = Category.latest.obs;
  int albumPage = 0;
  int songPage = 0;
  final songCount = 0.obs;
  final albumCount = 0.obs;
  final sort = Sort.asc.obs;
  final isLoadingMoreAlbum = false.obs;
  final isLoadingMoreSong = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSongCount(album.id);
    fetchAlbumCount(album.id);
    scrollAlbumCont.addListener(_loadMoreAlbum);
    scrollSongCont.addListener(_loadMoreSong);
  }

  void fetchSongCount(String id) async {
    int fetchCount = await NewArtistDetailsApi.getSongCount(id, albumPage, category.value, sort.value);
    songCount.value = fetchCount;
  }

  void fetchAlbumCount(String id) async {
    int fetchCount = await NewArtistDetailsApi.getAlbumCount(id, albumPage, category.value, sort.value);
    albumCount.value = fetchCount;
  }

  void _loadMoreAlbum() async {
    if(isLoadingMoreAlbum.value) return;
    if (scrollAlbumCont.position.pixels == scrollAlbumCont.position.maxScrollExtent) {
      isLoadingMoreAlbum.value = true;
      albumPage++;
      await fetchAlbums(album.id, albumPage).then((value) => isLoadingMoreAlbum.value = false);
    }
    update();
  }

  void _loadMoreSong() async {
    if(isLoadingMoreSong.value) return;
    if (scrollSongCont.position.pixels == scrollSongCont.position.maxScrollExtent) {
      isLoadingMoreSong.value = true;
      songPage++;
      await fetchSongs(album.id, songPage).then((value) => isLoadingMoreSong.value = false);
    }
    update();
  }

  Future<void> fetchAlbums(String text, int page) async {
    List<NewAlbum> fetchedList = await NewArtistDetailsApi.getAlbums(album.id, page, category.value, sort.value);
    artistSongAlbum.value.albums.addAll(fetchedList);
    update();
  }

  Future<void> fetchSongs(String text, int page) async {
    List<NewSong> fetchedList = await NewArtistDetailsApi.getSongs(album.id, page, category.value, sort.value);
    artistSongAlbum.value.songs.addAll(fetchedList);
    update();
  }
}