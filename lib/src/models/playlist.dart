import 'package:sonicity/src/models/image_url.dart';

class Playlist {
  final String id;
  final String name;
  final String songCount;
  final ImageUrl image;

  Playlist({
    required this.id,
    required this.name,
    required this.songCount,
    required this.image,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      songCount: json['songCount'],
      image: ImageUrl.fromJson(json['image']),
    );
  }
}