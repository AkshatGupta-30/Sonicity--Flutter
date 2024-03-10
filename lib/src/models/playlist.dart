import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
import 'package:super_string/super_string.dart';

class Playlist {
  final String id;
  final String name;
  final ImageUrl image;
  final String ? songCount;
  final String ? language;
  final List<Song> ? songs;

  Playlist({
    required this.id, required this.name, required this.image,
    this.songCount, this.language, this.songs
  });

  factory Playlist.detail(Map<String,dynamic> data) {
    List<Song> songs = [];
    if(data['songs'] != null) {
      for (var music in data['songs']) {
        songs.add(Song.forPlay(music));
      }
    }
    return Playlist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      songCount: data['songCount'] ?? "",
      language: data['language'].toString().title(),
      songs: songs
    );
  }

  factory Playlist.empty() {
    return Playlist(id: "", name: "", image: ImageUrl.empty());
  }

  factory Playlist.image(Map<String,dynamic> data) {
    return Playlist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
    );
  }

  factory Playlist.language(Map<String,dynamic> data) {
    return Playlist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      language: data['language'].toString().title()
    );
  }

  factory Playlist.songCount(Map<String,dynamic> data) {
    return Playlist(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      songCount: data['songCount']
    );
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

  factory Playlist.fromDb(Map<String,dynamic> json) {
    List<Map<String,dynamic>> imageData = [
      {"quality" : ImageQuality.q50x50, "url" : json["img_low"]},
      {"quality" : ImageQuality.q150x150, "url" : json["img_med"]},
      {"quality" : ImageQuality.q500x500, "url" : json["img_high"]},
    ];
    return Playlist(
      id: json['playlist_id'].toString(),
      name: json['name'],
      songCount: json['songCount'].toString(),
      language: json['language'],
      image: ImageUrl.fromJson(imageData),
    );
  }

  Map<String, dynamic> toDb() {
    return {
      "playlist_id" : id,
      "name" : name,
      "songCount" : songCount,
      "img_low" : image.lowQuality,
      "img_med" : image.medQuality,
      "img_high" : image.highQuality,
    };
  }

  bool isEmpty() {
    return id.isEmpty;
  }

  bool isNotEmpty() {
    return id.isNotEmpty;
  }
}