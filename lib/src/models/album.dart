import 'package:get/get.dart';
import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/song.dart';

class Album {
  final String id;
  final String name;
  final String ? artist;
  final ImageUrl image;
  final String ? year;
  final String ? releaseDate;
  final String ? songCount;
  final String ? primaryArtistsId;
  final String ? primaryArtists;
  final String ? language;
  final List<Song> ? songs;

  Album({
    required this.id,
    required this.name,
    this.artist,
    required this.image,
    this.year,
    this.releaseDate,
    this.songCount,
    this.primaryArtistsId,
    this.primaryArtists,
    this.language,
    this.songs,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    List<dynamic> songsList = json['songs'];
    List<Song> songs = songsList.map((song) => Song.fromJson(song)).toList();

    return Album(
      id: json['id'],
      name: json['name'],
      image: ImageUrl.fromJson(json['image']),
      year: json['year'],
      releaseDate: json['releaseDate'],
      songCount: json['songCount'],
      primaryArtistsId: json['primaryArtistsId'],
      primaryArtists: json['primaryArtists'],
      language: json['language'],
      songs: songs,
    );
  }

  factory Album.fromShortJson(Map<String, dynamic> json) {
    String language = json['language'].toString().capitalizeFirst!;
    return Album(
      id: json['id'],
      name: json['name'],
      image: ImageUrl.fromJson(json['image']),
      songCount: json['songCount'],
      language: language,
    );
  }

  factory Album.fromNameJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      image: ImageUrl(imageLinks: [])
    );
  }

  factory Album.fromSearchAllTop(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'] ?? json['title'],
      language:  json['language'].toString().capitalizeFirst,
      image: ImageUrl.fromJson(json['image'])
    );
  }

  factory Album.fromSearchAllAlbum(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'] ?? json['title'],
      artist: json['artist'],
      image: ImageUrl.fromJson(json['image'])
    );
  }

  factory Album.fromSearchAlbum(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'] ?? json['title'],
      songCount: json['songCount'],
      image: ImageUrl.fromJson(json['image'])
    );
  }

  factory Album.empty() {
    return Album(
      id: "",
      image: ImageUrl.empty(),
      name: ""
    );
  }

  bool isEmpty() {
    return id.isEmpty &&
        name.isEmpty &&
        (artist == null || artist!.isEmpty) &&
        image.isEmpty() &&
        (year == null || year!.isEmpty) &&
        (releaseDate == null || releaseDate!.isEmpty) &&
        (songCount == null || songCount!.isEmpty) &&
        (primaryArtistsId == null || primaryArtistsId!.isEmpty) &&
        (primaryArtists == null || primaryArtists!.isEmpty) &&
        (language == null || language!.isEmpty) &&
        (songs == null || songs!.isEmpty);
  }

  bool isNotEmpty() {
    return !isEmpty();
  }
}
