import 'package:sonicity/src/models/new_album.dart';

class NewTopAlbums {
  final List<NewAlbum> albums;
  NewTopAlbums({required this.albums});

  factory NewTopAlbums.fromJson({required List<NewAlbum> jsonList}) {
    return NewTopAlbums(albums: jsonList);
  }

  factory NewTopAlbums.empty() {
    return NewTopAlbums(albums: []);
  }
}