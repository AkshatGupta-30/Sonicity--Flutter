import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:super_string/super_string.dart';

class NewPlaylist {
  final String id;
  final String name;
  final ImageUrl image;
  final String ? songCount;
  final String ? language;
  final List<NewSong> ? songs;

  NewPlaylist({
    required this.id, required this.name, required this.image,
    this.songCount, this.language, this.songs
  });

  factory NewPlaylist.detail(Map<String,dynamic> data) {
    List<NewSong> songs = [];
    if(data['songs'] != null) {
      for (var music in data['songs']) {
        songs.add(NewSong.detail(music));
      }
    }
    return NewPlaylist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      songCount: data['songCount'] ?? "",
      language: data['language'].toString().title(),
      songs: songs
    );
  }

  factory NewPlaylist.empty() {
    return NewPlaylist(id: "", name: "", image: ImageUrl.empty());
  }

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "name" : name,
      "image" : image.toMap(),
      "songCount" : songCount,
      "language" : language,
      "songs" : songs!.map((song) => song.toMap()).toList(),
    };
  }

  bool isEmpty() {
    return id.isEmpty;
  }

  bool isNotEmpty() {
    return id.isNotEmpty;
  }
}