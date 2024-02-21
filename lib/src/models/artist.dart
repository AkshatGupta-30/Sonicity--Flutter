import 'package:sonicity/src/models/image_url.dart';

class Artist {
  final String id;
  final String name;
  final ImageUrl image;
  final String? songCount;

  Artist({
    required this.id,
    required this.name,
    required this.image,
    required this.songCount
  });

  factory Artist.fromShortJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      image: ImageUrl.fromJson(json['image']),
      songCount: json['songCount']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image.toMap(),
      'songCount': songCount,
    };
  }
}