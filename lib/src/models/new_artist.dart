import 'package:sonicity/src/models/image_url.dart';

class NewArtist {
  final String id;
  final String name;
  final ImageUrl image;
  final String ? role;
  final String ? description;
  final String ? dominantLanguage;
  final String ? dominantType;
  final String ? dob;
  final String ? fb;
  final String ? twitter;
  final String ? wiki;
  final List<String> ? availableLanguages;

  NewArtist({
    required this.id, required this.name, required this.image,
    this.role, this.description,
    this.dominantLanguage, this.dominantType, this.dob, this.fb,
    this.twitter, this.wiki, this.availableLanguages,
  });

  factory NewArtist.detail(Map<String,dynamic> data) {
    return NewArtist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      role: data['role'],
      description: data['description'],
      dominantLanguage: data['dominantLanguage'],
      dominantType: data['dominantType'],
      dob: data['dob'],
      fb: data['fb'],
      twitter: data['twitter'],
      wiki: data['wiki'],
      availableLanguages: data['availableLanguages'].toString().split(",").toList().toSet().toList(),
    );
  }

  factory NewArtist.image(Map<String,dynamic> data) {
    return NewArtist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
    );
  }

  factory NewArtist.description(Map<String,dynamic> data) {
    return NewArtist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      description: data['description']
    );
  }

  factory NewArtist.empty() {
    return NewArtist(id: "", name: "", image: ImageUrl.empty());
  }

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "name" : name,
      "image" : image.toMap(),
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

  bool isEmpty() {
    return id.isEmpty;
  }

  bool isNotEmpty() {
    return id.isNotEmpty;
  }
}