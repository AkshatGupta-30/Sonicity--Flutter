import 'package:sonicity/src/models/image_url.dart';
import 'package:super_string/super_string.dart';

class Artist {
  final String id;
  final String name;
  final ImageUrl image;
  final String ? dominantLanguage;
  final String ? dominantType;
  final String ? songCount;
  final String ? description;

  Artist({
    required this.id,
    required this.name,
    required this.image,
    this.dominantLanguage,
    this.dominantType,
    this.songCount,
    this.description
  });

  factory Artist.fromDetail(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      image: ImageUrl.fromJson(json['image']),
      dominantLanguage: json['dominantLanguage'].toString().title(),
      dominantType: json['dominantType'].toString().title(),
      songCount: json['songCount'],
      description: json['description'].toString().title(),
    );
  }

  factory Artist.withImageSongCount(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      image: ImageUrl.fromJson(json['image']),
      songCount: json['songCount'],
    );
  }

  factory Artist.fromImageDescription(Map<String, dynamic> json) {
    String ? des;
    if(json['description'] == null) {
      des = json['description'].toString().title();
    } else {
      json['role'].toString().title();
    }
    return Artist(
      id: json['id'],
      name: json['name'] ?? json['title'],
      image: ImageUrl.fromJson(json['image']),
      description: des,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image.toMap(),
      'songCount': songCount,
      "description" : description
    };
  }
}