import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/song.dart';

class Album {
  final String id;
  final String name;
  final ImageUrl image;
  final String ? year;
  final String ? releaseDate;
  final String ? songCount;
  final String ? primaryArtistsId;
  final String ? primaryArtists;
  final List<Song> ? songs;

  Album({
    required this.id,
    required this.name,
    required this.image,
    this.year,
    this.releaseDate,
    this.songCount,
    this.primaryArtistsId,
    this.primaryArtists,
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
      songs: songs,
    );
  }
}
