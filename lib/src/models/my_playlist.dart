import 'package:sonicity/src/database/my_playlists_database.dart';
import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/song.dart';

class MyPlaylist {
  final String id;
  final String name;
  final ImageUrl image;
  final String songCount;
  final DateTime dateCreated;
  final List<Song> ? songs;

  MyPlaylist({
    required this.id, required this.name, required this.image,
    required this.dateCreated, required this.songCount, this.songs
  });

  factory MyPlaylist.fromDb(Map<String, dynamic> data) {
    List<String> imageList = data[MyPlaylistsDatabase.colImages].toString().split(MyPlaylistsDatabase.specCharQuality);
    List<Map<String, dynamic>> forImageUrl = [
      {'quality' : '50x50', 'link' : imageList[0]},
      {'quality' : '150x150', 'link' : imageList[1]},
      {'quality' : '500x500', 'link' : imageList[2]},
    ];
    return MyPlaylist(
      id: data[MyPlaylistsDatabase.colPlaylistId].toString(),
      name: data[MyPlaylistsDatabase.colName].toString().replaceAll('_', ' '),
      songCount: data[MyPlaylistsDatabase.colSongCount].toString(),
      image: ImageUrl.fromJson(forImageUrl),
      dateCreated: DateTime.parse(data[MyPlaylistsDatabase.colDateCreated]),
    );
  }

  factory MyPlaylist.empty() {
    return MyPlaylist(id: '', name: '', image: ImageUrl.empty(), dateCreated: DateTime.now(), songCount: '');
  }
}