import 'package:sonicity/src/models/image_url.dart';

class Artist {
  final String id;
  final String name;
  final ImageUrl image;
  final String? songCount;
  final String ? description;

  Artist({
    required this.id,
    required this.name,
    required this.image,
    this.songCount,
    this.description
  });

  factory Artist.fromShortJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      image: ImageUrl.fromJson(json['image']),
      songCount: json['songCount']
    );
  }

  factory Artist.fromSearchAllTop(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      image: ImageUrl.fromJson(json['image']),
      description: json['description']
    );
  }

  factory Artist.fromSearchAll(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      image: ImageUrl.fromJson(json['image']),
      description: json['description']
    );
  }

  factory Artist.fromSearchArtist(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      image: ImageUrl.fromJson(json['image']),
      description: json['role']
    );
  }

  get language => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image.toMap(),
      'songCount': songCount,
    };
  }
}