import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class StarredController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final selectedTab = 0.obs;
  
  final starDb = GetIt.instance<StarredDatabase>();
  final songs = <Song>[].obs;
  final albums = <Album>[].obs;
  final artists = <Artist>[].obs;
  final playlists = <Playlist>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() => selectedTab.value = tabController.index);
    getAll();
  }

  void getAll() async {
    List<Song> so = [];
    List<Album> al = [];
    List<Artist> ar = [];
    List<Playlist> pl = [];
    (so, al, ar, pl) = await starDb.all;

    songs.value = so;
    albums.value = al;
    artists.value = ar;
    playlists.value = pl;
  }

  void sortSongs(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? songs.sort((a, b) => a.name.compareTo(b.name))
        : songs.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? songs.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : songs.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? songs.sort((a, b) => a.year!.compareTo(b.year!))
        : songs.sort((a, b) => b.year!.compareTo(a.year!));
    }
    update();
  }

  void sortAlbums(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? albums.sort((a, b) => a.name.compareTo(b.name))
        : albums.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? albums.sort((a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!)))
        : albums.sort((a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!)));
    }
    update();
  }
  
  void sortArtists(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? artists.sort((a, b) => a.name.compareTo(b.name))
        : artists.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? artists.sort((a, b) => a.description!.compareTo(b.description!))
        : artists.sort((a, b) => b.description!.compareTo(a.description!));
    }
    update();
  }

  void sortPlaylists(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? playlists.sort((a, b) => a.name.compareTo(b.name))
        : playlists.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? playlists.sort((a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!)))
        : playlists.sort((a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!)));
    }
    update();
  }
}