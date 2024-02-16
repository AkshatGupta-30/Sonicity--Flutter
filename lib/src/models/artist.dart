import 'package:sonicity/src/models/image_url.dart';

class Artist {
  final String id;
  final String name;
  final String url;
  final ImageUrl image;
  final String songCount;

  Artist({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.songCount
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      image: ImageUrl.fromJson(json['image']),
      songCount: json['songCount']
    );
  }
}