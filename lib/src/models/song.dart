import 'package:sonicity/src/models/album.dart';
import 'package:sonicity/src/models/download_url.dart';
import 'package:sonicity/src/models/image_url.dart';

class Song {
  final String id;
  final String name;
  final Album album;
  final String year;
  final String releaseDate;
  final String duration;
  final String primaryArtists;
  final String primaryArtistsId;
  final String ? featuredArtists;
  final String ? featuredArtistsId;
  final String ? playCount;
  final String ? language;
  final bool ? hasLyrics;
  final ImageUrl image;
  final DownloadUrl downloadUrl;

  Song({
    required this.id,
    required this.name,
    required this.album,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.featuredArtists,
    required this.featuredArtistsId,
    required this.playCount,
    required this.language,
    required this.hasLyrics,
    required this.image,
    required this.downloadUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      name: json['name'],
      album: Album.fromJson(json['album']),
      year: json['year'],
      releaseDate: json['releaseDate'],
      duration: json['duration'],
      primaryArtists: json['primaryArtists'],
      primaryArtistsId: json['primaryArtistsId'],
      featuredArtists: json['featuredArtists'],
      featuredArtistsId: json['featuredArtistsId'],
      playCount: json['playCount'],
      language: json['language'],
      hasLyrics: json['hasLyrics'],
      image: ImageUrl.fromJson(json['image']),
      downloadUrl: json['downloadUrl'],
    );
  }
}
