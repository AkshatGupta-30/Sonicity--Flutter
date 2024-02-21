import 'package:sonicity/src/models/image_url.dart';

class Playlist {
  final String id;
  final String name;
  final ImageUrl image;
  final String ? songCount;
  final String ? language;

  Playlist({
    required this.id,
    required this.name,
    required this.image,
    this.songCount,
    this.language
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      songCount: json['songCount'],
      image: ImageUrl.fromJson(json['image']),
      language: json['language']
    );
  }
}