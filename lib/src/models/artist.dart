import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
import 'package:super_string/super_string.dart';

class Artist {
  final String id;
  final String name;
  final ImageUrl ? image;
  final String ? role;
  final String ? description;
  final String ? dominantLanguage;
  final String ? dominantType;
  final String ? dob;
  final String ? fb;
  final String ? twitter;
  final String ? wiki;
  final List<String> ? availableLanguages;

  Artist({
    required this.id, required this.name, this.image,
    this.role, this.description,
    this.dominantLanguage, this.dominantType, this.dob, this.fb,
    this.twitter, this.wiki, this.availableLanguages,
  });

  factory Artist.detail(Map<String,dynamic> data) {
    return Artist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      role: data['role'],
      description: data['description'].toString().title(),
      dominantLanguage: data['dominantLanguage'].toString().title(),
      dominantType: data['dominantType'].toString().title(),
      dob: data['dob'],
      fb: data['fb'],
      twitter: data['twitter'],
      wiki: data['wiki'],
      availableLanguages: data['availableLanguages'].toString().split(",").toList().toSet().toList(),
    );
  }

  factory Artist.image(Map<String,dynamic> data) {
    return Artist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
    );
  }

  factory Artist.description(Map<String,dynamic> data) {
    return Artist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      description: data['description'] ?? data['role']
    );
  }

  

  factory Artist.type(Map<String,dynamic> data) {
    return Artist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      dominantType: data['type'].toString().title()
    );
  }

  factory Artist.name(Map<String,dynamic> data) {
    return Artist(
      id: data['id'],
      name: data['name'] ?? data['title'],
    );
  }

  factory Artist.empty() {
    return Artist(id: "", name: "", image: ImageUrl.empty());
  }

  Map<String, dynamic> toMap() {
    List<Map<String,dynamic>> img = [];
    if(image != null) {
      img = image!.toMap();
    }
    return {
      "id" : id,
      "name" : name,
      "image" : img,
      "role" : role,
      "description" : description,
      "dominantLanguage" : dominantLanguage,
      "dominantType" : dominantType,
      "dob" : dob,
      "fb" : fb,
      "twitter" : twitter,
      "wiki" : wiki,
      "availableLanguages" : availableLanguages.toString(),
    };
  }

  factory Artist.fromDb(Map<String,dynamic> json) {
    List<Map<String,dynamic>> imageData = [
      {"quality" : ImageQuality.q50x50, "url" : json["img_low"]},
      {"quality" : ImageQuality.q150x150, "url" : json["img_med"]},
      {"quality" : ImageQuality.q500x500, "url" : json["img_high"]},
    ];
    return Artist(
      id: json['artist_id'],
      name: json['name'],
      dominantType: json['dominantType'],
      dominantLanguage: json['dominantLangauge'],
      description: json['description'],
      dob: json['dob'],
      fb: json['fb'],
      role: json['role'],
      twitter: json['twitter'],
      wiki: json['wiki'],
      availableLanguages: json['availableLanguages'].toString().split(", ").toSet().toList(),
      image: ImageUrl.fromJson(imageData),
    );
  }

  Map<String, dynamic> toDb() {
    return {
      "artist_id" : id,
      "name" : name,
      "dominantType" : dominantType,
      "img_low" : image!.lowQuality,
      "img_med" : image!.medQuality,
      "img_high" : image!.highQuality,
    };
  }

  bool isEmpty() {
    return id.isEmpty;
  }

  bool isNotEmpty() {
    return id.isNotEmpty;
  }
}