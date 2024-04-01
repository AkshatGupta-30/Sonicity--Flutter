import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class MyPlaylist {
  final String id;
  final String name;
  final List<ImageUrl> image;
  final String songCount;
  final DateTime dateCreated;
  List<Song> ? songs;

  MyPlaylist({
    required this.id, required this.name, required this.image,
    required this.dateCreated, required this.songCount, this.songs
  });

  factory MyPlaylist.fromDb(Map<String, dynamic> data) {
    List<String> songImageList = data[colImages].toString().split(dbMyPlaylistsSpecCharSong);
    List<ImageUrl> imageUrls = [];
    for(var songImage in songImageList) {
      List<String> imageQualityList = songImage.toString().split(dbMyPlaylistsSpecCharQuality);
      List<Map<String, dynamic>> imageUrlMap = [
        {'quality' : '50x50', 'url' : imageQualityList[0]},
        {'quality' : '150x150', 'url' : imageQualityList[1]},
        {'quality' : '500x500', 'url' : imageQualityList[2]},
      ];
      imageUrls.add(ImageUrl.fromJson(imageUrlMap));
    }
    return MyPlaylist(
      id: data[colPlaylistId].toString(),
      name: data[colName].toString().replaceAll('_', ' '),
      songCount: data[colSongCount].toString(),
      image: imageUrls,
      dateCreated: DateTime.parse(data[colDateCreated]),
    );
  }

  factory MyPlaylist.empty() {
    return MyPlaylist(id: '', name: '', image: [], dateCreated: DateTime.now(), songCount: '');
  }
}