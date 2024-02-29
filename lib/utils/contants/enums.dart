enum Views {
  navigation, home, library, queue,
  searchAll, viewAllSearchSong, viewAllSearchAlbum, viewAllSearchArtist, viewAllSearchPlaylist,
  songDetails, albumDetails, artistDetails, playlistDetails,
  allSongs, recentsSongs, starred, myStorage, allPlaylists, allAlbums, allArtists, stats;

  String get toText {
    switch(this) {
      case Views.navigation: return "Navigation";
      case Views.home: return "HomeView";
      case Views.library: return "LibraryView";
      case Views.queue: return "QueueView";
      case Views.searchAll: return "SearchAllView";
      case Views.viewAllSearchSong: return "ViewAllSearchSongView";
      case Views.viewAllSearchAlbum: return "ViewAllSearchAlbumView";
      case Views.viewAllSearchArtist: return "ViewAllSearchArtistView";
      case Views.viewAllSearchPlaylist: return "ViewAllSearch PlaylistView";
      case Views.songDetails: return "Song DetailsView";
      case Views.albumDetails: return "Album DetailsView";
      case Views.artistDetails: return "Artist DetailsView";
      case Views.playlistDetails: return "Playlist DetailsView";
      case Views.allSongs: return "AllSongsView";
      case Views.recentsSongs: return "RecentsSongsView";
      case Views.starred: return "StarredView";
      case Views.myStorage: return "MyStorageView";
      case Views.allPlaylists: return "All PlaylistsView";
      case Views.allAlbums: return "AllAlbumsView";
      case Views.allArtists: return "AllArtistsView";
      case Views.stats: return "StatsView";
      default: return "ToDoView";
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