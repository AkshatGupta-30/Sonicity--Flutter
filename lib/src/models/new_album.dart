import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:sonicity/src/models/new_song.dart';
import 'package:super_string/super_string.dart';

class NewAlbum {
  final String id;
  final String name;
  final ImageUrl ? image;
  final String ? year;
  final String ? releaseDate;
  final String ? language;
  final String ? description;
  final String ? songCount;
  final List<NewArtist> ? artists;
  final List<NewSong> ? songs;

  NewAlbum({
    required this.id, required this.name, this.image,
    this.language, this.description,
    this.year, this.releaseDate, this.songCount, this.artists, this.songs
  });

  factory NewAlbum.detail(Map<String,dynamic> data) {
    List<NewArtist> arts = [];
    if(data['artists'] != null) {
      for(var ar in data['artists']) {
        arts.add(NewArtist.image(ar));
      }
    }
    List<NewSong> musics = [];
    if(data['songs'] != null) {
      for(var so in data['songs']) {
        musics.add(NewSong.detail(so));
      }
    }
    return NewAlbum(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      year: data['year'],
      releaseDate: data['releaseDate'],
      language: data['language'].toString().title(),
      description: data['description'],
      songCount: data['songCount'],
      artists: arts,
      songs: musics
    );
  }

  factory NewAlbum.image(Map<String,dynamic> data) {
    return NewAlbum(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
    );
  }

  factory NewAlbum.name(Map<String,dynamic> data) {
    return NewAlbum(
      id: data['id'],
      name: data['name'] ?? data['title'],
    );
  }

  factory NewAlbum.language(Map<String,dynamic> data) {
    return NewAlbum(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      language: data['language'].toString().title()
    );
  }

  factory NewAlbum.songCount(Map<String,dynamic> data) {
    return NewAlbum(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      songCount: data['songCount']
    );
  }

  factory NewAlbum.empty() {
    return NewAlbum(id: "", name: "", image: ImageUrl.empty());
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

  bool isEmpty() {
    return id.isEmpty;
  }

  bool isNotEmpty() {
    return id.isNotEmpty;
  }
}