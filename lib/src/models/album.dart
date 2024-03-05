import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/sections/cover_image_section.dart';
import 'package:super_string/super_string.dart';

class Album {
  final String id;
  final String name;
  final ImageUrl ? image;
  final String ? year;
  final String ? releaseDate;
  final String ? language;
  final String ? description;
  final String ? songCount;
  final List<Artist> ? artists;
  final List<Song> ? songs;

  Album({
    required this.id, required this.name, this.image,
    this.language, this.description,
    this.year, this.releaseDate, this.songCount, this.artists, this.songs
  });

  factory Album.detail(Map<String,dynamic> data) {
    List<Artist> arts = [];
    if(data['artists'] != null) {
      for(var ar in data['artists']) {
        arts.add(Artist.detail(ar));
      }
    }
    List<Song> musics = [];
    if(data['songs'] != null) {
      for(var so in data['songs']) {
        musics.add(Song.forPlay(so));
      }
    }
    return Album(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      year: data['year'],
      releaseDate: data['releaseDate'],
      language: data['language'].toString().title(),
      description: data['description'].toString().title(),
      songCount: data['songCount'],
      artists: arts,
      songs: musics
    );
  }

  factory Album.image(Map<String,dynamic> data) {
    return Album(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
    );
  }

  factory Album.name(Map<String,dynamic> data) {
    return Album(
      id: data['id'],
      name: data['name'] ?? data['title'],
    );
  }

  factory Album.language(Map<String,dynamic> data) {
    return Album(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      language: data['language'].toString().title()
    );
  }

  factory Album.songCount(Map<String,dynamic> data) {
    return Album(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      songCount: data['songCount']
    );
  }

  factory Album.year(Map<String,dynamic> data) {
    return Album(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      songCount: data['songCount'],
      year: data['year']
    );
  }

  factory Album.empty() {
    return Album(id: "", name: "", image: ImageUrl.empty());
  }

  Map<String, dynamic> toMap() {
    List<Map<String,dynamic>> imgs = [];
    if(image != null) {
      imgs = image!.toMap();
    }
    List<Map<String,dynamic>> arts = [];
    if(artists != null) {
      for(var ar in artists!) {
        arts.add(ar.toMap());
      }
    }
    List<Map<String,dynamic>> musics = [];
    if(songs != null) {
      for(var so in songs!) {
        musics.add(so.toMap());
      }
    }
    return {
      "id" : id,
      "name" : name,
      "image" : imgs,
      "year" : year,
      "releaseDate" : releaseDate,
      "language" : language,
      "description" : description,
      "songCount" : songCount,
      "artists" : arts,
      "songs" : musics,
    };
  }

  factory Album.fromDb(Map<String,dynamic> json) {
    List<Map<String,dynamic>> imageData = [
      {"quality" : ImageQuality.q50x50, "link" : json["img_low"]},
      {"quality" : ImageQuality.q150x150, "link" : json["img_med"]},
      {"quality" : ImageQuality.q500x500, "link" : json["img_high"]},
    ];
    return Album(
      id: json['album_id'],
      name: json['name'],
      songCount: json['songCount'],
      image: ImageUrl.fromJson(imageData),
    );
  }

  Map<String, dynamic> toDb() {
    return {
      "album_id" : id,
      "name" : name,
      "songCount" : songCount,
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