import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sonicity/src/database/recents_database.dart';
import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/enums.dart';

class RecentsController extends GetxController with GetTickerProviderStateMixin {
  final _recentDatabase = GetIt.instance<RecentsDatabase>();
  late TabController tabController;
  final selectedTab = 0.obs;
  final recentSongs = <Song>[].obs;
  final recentAlbums = <Album>[].obs;
  final recentArtists = <Artist>[].obs;
  final recentPlaylists = <Playlist>[].obs;

  @override
  void onInit() {
    super.onInit();
    _get();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() => selectedTab.value = tabController.index);
  }

  void _get() async {
    List<Song> songs = [];
    List<Album> albums = [];
    List<Artist> artists = [];
    List<Playlist> playlists = [];
    (songs, albums, artists, playlists) = await _recentDatabase.all;
    
    recentSongs.value = songs;
    recentAlbums.value = albums;
    recentArtists.value = artists;
    recentPlaylists.value = playlists;
  }

  void sortSongs(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => a.name.compareTo(b.name))
        : recentSongs.sort((a, b) => b.name.compareTo(a.name));
    } else if(sortType == SortType.duration) {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => int.parse(a.duration!).compareTo(int.parse(b.duration!)))
        : recentSongs.sort((a, b) => int.parse(b.duration!).compareTo(int.parse(a.duration!)));
    } else {
      (sortBy == Sort.asc)
        ? recentSongs.sort((a, b) => a.year!.compareTo(b.year!))
        : recentSongs.sort((a, b) => b.year!.compareTo(a.year!));
    }
    update();
  }

  void sortAlbums(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? recentAlbums.sort((a, b) => a.name.compareTo(b.name))
        : recentAlbums.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? recentAlbums.sort((a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!)))
        : recentAlbums.sort((a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!)));
    }
    update();
  }
  
  void sortArtists(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? recentArtists.sort((a, b) => a.name.compareTo(b.name))
        : recentArtists.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? recentArtists.sort((a, b) => a.description!.compareTo(b.description!))
        : recentArtists.sort((a, b) => b.description!.compareTo(a.description!));
    }
    update();
  }

  void sortPlaylists(SortType sortType, Sort sortBy) {
    if(sortType == SortType.name) {
      (sortBy == Sort.asc)
        ? recentPlaylists.sort((a, b) => a.name.compareTo(b.name))
        : recentPlaylists.sort((a, b) => b.name.compareTo(a.name));
    } else {
      (sortBy == Sort.asc)
        ? recentPlaylists.sort((a, b) => int.parse(a.songCount!).compareTo(int.parse(b.songCount!)))
        : recentPlaylists.sort((a, b) => int.parse(b.songCount!).compareTo(int.parse(a.songCount!)));
    }
    update();
  }
}