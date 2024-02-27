import 'package:sonicity/src/models/download_url.dart';
import 'package:sonicity/src/models/image_url.dart';
import 'package:sonicity/src/models/new_album.dart';
import 'package:sonicity/src/models/new_artist.dart';
import 'package:super_string/super_string.dart';

class NewSong {
  final String id;
  final String name;
  final ImageUrl image;
  final DownloadUrl downloadUrl;
  final bool hasLyrics;
  final String ? year;
  final String ? releaseDate;
  final String ? duration;
  final List<NewArtist> ? artists;
  final NewAlbum ? album;
  final String ? language;

  NewSong({
    required this.id, required this.name, required this.image, required this.downloadUrl, required this.hasLyrics,
    this.year, this.releaseDate, this.duration, this.artists, this.album, this.language
  });

  factory NewSong.detail(Map<String,dynamic> data) {
    List<NewArtist> arts = [];
    if(data['artists'] != null) {
      for (var ar in data['artists']) {
        arts.add(NewArtist.image(ar));
      }
    }
    return NewSong(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      downloadUrl: DownloadUrl.fromJson(data['downloadUrl']),
      hasLyrics: (data['hasLyrics'] == 'true') ? true : false,
      year: data['year'],
      releaseDate: data['releaseDate'],
      duration: data['duration'],
      artists: arts,
      album: NewAlbum.name(data['album']),
      language: data['language'].toString().title()
    );
  }

  factory NewSong.empty() {
    return NewSong(id: "", name: "", image: ImageUrl.empty(), downloadUrl: DownloadUrl.empty(), hasLyrics: false);
  }

  Map<String, dynamic> toMap() {
    List<NewArtist> arts = [];
    if(artists != null) {
      arts = artists!;
    }
    return {
      "id" : id,
      "name" : name,
      "image" : image.toMap(),
      "downloadUrl" : downloadUrl.toMap(),
      "hasLyrics" : hasLyrics,
      "year" : year,
      "releaseDate" : releaseDate,
      "duration" : duration,
      "artists" : arts.map((artist) => artist.toMap()).toList(),
      "album" : album!.toMap(),
      "language" : language,
    };
  }

  bool isEmpty() {
    return id.isEmpty;
  }

  bool isNotEmpty() {
    return id.isNotEmpty;
  }

  

  String get title => name;
  String get subtitle {
    String text = "";
    if(artists == null || artists!.isEmpty) {
      text = language!;
    } else {
      text = artists!.first.name;
    }
    return "${album!.name} ▪ $text";
  }
}