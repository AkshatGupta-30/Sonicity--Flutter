enum Routes {
  navigation, home, library, queue,
  searchAll, viewAllSearchSong, viewAllSearchAlbum, viewAllSearchArtist, viewAllSearchPlaylist,
  songDetails, albumDetails, artistDetails, playlistDetails,
  allSongs, recentsSongs, starred, myStorage, allPlaylists, allAlbums, allArtists, stats;

  String get toText {
    switch(this) {
      case Routes.navigation: return "/Navigation";
      case Routes.home: return "/HomeView";
      case Routes.library: return "/LibraryView";
      case Routes.queue: return "/QueueView";
      case Routes.searchAll: return "/SearchAllView";
      case Routes.viewAllSearchSong: return "/ViewAllSearchSongView";
      case Routes.viewAllSearchAlbum: return "/ViewAllSearchAlbumView";
      case Routes.viewAllSearchArtist: return "/ViewAllSearchArtistView";
      case Routes.viewAllSearchPlaylist: return "/ViewAllSearch PlaylistView";
      case Routes.songDetails: return "/Song DetailsView";
      case Routes.albumDetails: return "/Album DetailsView";
      case Routes.artistDetails: return "/Artist DetailsView";
      case Routes.playlistDetails: return "/Playlist DetailsView";
      case Routes.allSongs: return "/AllSongsView";
      case Routes.recentsSongs: return "/RecentsSongsView";
      case Routes.starred: return "/StarredView";
      case Routes.myStorage: return "/MyStorageView";
      case Routes.allPlaylists: return "/All PlaylistsView";
      case Routes.allAlbums: return "/AllAlbumsView";
      case Routes.allArtists: return "/AllArtistsView";
      case Routes.stats: return "/StatsView";
      default: return "/ToDoView";
    }
  }
}

enum FirebaseCollections {
  report, users;

  String get toText{
    switch (this) {
      case FirebaseCollections.report: return "App Report";
      case FirebaseCollections.users: return "Users";
      default: return "None";
    }
  }
}

enum StorageCollections {
  report;

  String get toText{
    switch (this) {
      case StorageCollections.report: return "App Report Screenshots";
      default: return "None";
    }
  }
}