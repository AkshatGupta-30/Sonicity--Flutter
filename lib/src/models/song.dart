import 'package:audio_service/audio_service.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:super_string/super_string.dart';

class Song {
  final String id;
  final String name;
  final ImageUrl image;
  final DownloadUrl downloadUrl;
  final bool hasLyrics;
  final String ? year;
  final String ? releaseDate;
  final String ? duration;
  final List<Artist> ? artists;
  final Album ? album;
  final String ? language;

  Song({
    required this.id, required this.name, required this.image, required this.downloadUrl, required this.hasLyrics,
    this.year, this.releaseDate, this.duration, this.artists, this.album, this.language
  });

  factory Song.detail(Map<String,dynamic> data) {
    List<Artist> arts = [];
    if(data['artists'] != null) {
      for (var ar in data['artists']) {
        arts.add(Artist.image(ar));
      }
    }
    return Song(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      downloadUrl: DownloadUrl.fromJson(data['downloadUrl']),
      hasLyrics: (data['hasLyrics'] == 'true') ? true : false,
      year: data['year'].toString(),
      releaseDate: data['releaseDate'],
      duration: data['duration'].toString(),
      artists: arts,
      album: Album.image(data['album']),
      language: data['language'].toString().title()
    );
  }

  factory Song.forPlay(Map<String,dynamic> data) {
    List<Artist> arts = [];
    if(data['artists'] != null) {
      for (var ar in data['artists']) {
        arts.add(Artist.name(ar));
      }
    }
    return Song(
      id: data['id'],
      name: data['name'] ?? data['title'],
      image: ImageUrl.fromJson(data['image']),
      downloadUrl: DownloadUrl.fromJson(data['downloadUrl']),
      hasLyrics: (data['hasLyrics'].toString() == 'true') ? true : false,
      year: data['year'].toString(),
      releaseDate: data['releaseDate'],
      duration: data['duration'].toString(),
      artists: arts,
      album: Album.name(data['album']),
      language: data['language'].toString().title()
    );
  }

  factory Song.empty() {
    return Song(id: "", name: "", image: ImageUrl.empty(), downloadUrl: DownloadUrl.empty(), hasLyrics: false);
  }

  get songCount => null;

  Map<String, dynamic> toMap() {
    List<Artist> arts = [];
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

  factory Song.fromDb(Map<String,dynamic> json) {
    Album album = Album(id: json["album_id"], name: json["album_name"]);
    List<Artist> artists = [];
    List<String> artIds = json["artist_ids"].toString().split(",");
    List<String> artNames = json["artist_names"].toString().split(",");
    for (int i=0; i<artIds.length; i++) {
      artists.add(Artist.name({'id' : artIds[i], 'name' : artNames[i]}));
    }
    List<Map<String,dynamic>> imageData = [
      {"quality" : ImageQuality.q50x50, "url" : json["img_low"]},
      {"quality" : ImageQuality.q150x150, "url" : json["img_med"]},
      {"quality" : ImageQuality.q500x500, "url" : json["img_high"]},
    ];
    List<Map<String,dynamic>> downloadData = [
      {"quality" : DownloadQuality.q12kbps, "url" : json["download_12kbps"]},
      {"quality" : DownloadQuality.q48kbps, "url" : json["download_48kbps"]},
      {"quality" : DownloadQuality.q96kbps, "url" : json["download_96kbps"]},
      {"quality" : DownloadQuality.q160kbps, "url" : json["download_160kbps"]},
      {"quality" : DownloadQuality.q320kbps, "url" : json["download_320kbps"]}
    ];
    return Song(
      id: json['song_id'],
      name: json['name'],
      album: album,
      artists: artists,
      hasLyrics: (json['hasLyrics'] == 1),
      year: json['year'].toString(),
      releaseDate: json['releaseDate'],
      duration: json['duration'].toString(),
      language: json['language'],
      image: ImageUrl.fromJson(imageData),
      downloadUrl: DownloadUrl.fromJson(downloadData)
    );
  }

  Map<String, dynamic> toDb() {
    List<String> artistsIds = [];
    List<String> artistsNames = [];
    for(Artist artist in artists!) {
      artistsIds.add(artist.id);
      artistsNames.add(artist.name);
    }
    return {
      "song_id" : id,
      "name" : name,
      "album_id" : album!.id,
      "album_name" : album!.name,
      "artist_ids" : artistsIds.join(","),
      "artist_names" : artistsNames.join(","),
      "hasLyrics" : (hasLyrics) ? 1 : 0,
      "year" : year,
      "releaseDate" : releaseDate,
      "duration" : duration,
      "language" : language,
      "img_low" : image.lowQuality,
      "img_med" : image.medQuality,
      "img_high" : image.highQuality,
      "download_12kbps" : downloadUrl.q12kbps,
      "download_48kbps" : downloadUrl.q48kbps,
      "download_96kbps" : downloadUrl.q96kbps,
      "download_160kbps" : downloadUrl.q160kbps,
      "download_320kbps" : downloadUrl.q320kbps,
    };
  }

  Map<String, dynamic> toDbImgsMap(ImgQuality quality) {
    if(quality == ImgQuality.low) {
      return {"song_id" : id, "url" : image.lowQuality};
    } else if(quality == ImgQuality.med) {
      return {"song_id" : id, "url" : image.medQuality};
    } else {
      return {"song_id" : id, "url" : image.highQuality};
    }
  }

  Map<String, dynamic> toDbDownloadloadsMap(String quality) {
    if(quality == DownloadQuality.q12kbps) {
      return {"song_id" : id, "url" : downloadUrl.q12kbps};
    } else if(quality == DownloadQuality.q48kbps) {
      return {"song_id" : id, "url" : downloadUrl.q48kbps};
    } else if(quality == DownloadQuality.q96kbps) {
      return {"song_id" : id, "url" : downloadUrl.q96kbps};
    } else if(quality == DownloadQuality.q160kbps) {
      return {"song_id" : id, "url" : downloadUrl.q160kbps};
    } else {
      return {"song_id" : id, "url" : downloadUrl.q320kbps};
    }
  }

  factory Song.fromMediaItem(MediaItem mediaItem) {
    List<Artist> artists = [];
    for (Map<String, dynamic> artist in mediaItem.extras!['artists']) artists.add(Artist.name(artist));
    return Song(
      id: mediaItem.id,
      name: mediaItem.title,
      image: ImageUrl.fromJson(mediaItem.extras!['image']),
      downloadUrl: DownloadUrl.fromJson(mediaItem.extras!['downloadUrl']),
      hasLyrics: mediaItem.extras!['hasLyrics'],
      year: mediaItem.extras!['year'],
      releaseDate: mediaItem.extras!['releaseDate'],
      duration: mediaItem.extras!['duration'],
      artists: artists,
      album: Album.name(mediaItem.extras!['album']),
      language: mediaItem.extras!['language'],
    );
  }

  MediaItem toMediaItem({bool addedByAutoplay = false, bool autoplay = true, String? playlistBox}) {
    List<Map<String, dynamic>> artistsMap = [];
    if(artists != null) {
      for (var artist in artists!) artistsMap.add(artist.toMap());
    }

    return MediaItem(
      id: id,
      album: album!.name,
      artist: artistsName,
      duration: Duration(seconds: int.parse(duration!)),
      title: name,
      displayTitle: title,
      displaySubtitle: subtitle,
      artUri: Uri.parse(image.highQuality),
      genre: language ?? '',
      extras: {
        'user_id': id,
        'url': downloadUrl.link,
        'album_id': album!.id,
        'addedByAutoplay': addedByAutoplay,
        'autoplay': autoplay,
        'playlistBox': playlistBox,
        'album': album!.toMap(),
        'artists': artists,
        'duration': duration ?? '',
        'year': year ?? '',
        'releaseDate': releaseDate ?? '',
        'language': language ?? '',
        'image': image.toMap(),
        'downloadUrl':  downloadUrl.toMap(),
        'hasLyrics': hasLyrics
      },
    );
  }

  bool isEmpty() {
    return id.isEmpty;
  }

  bool isNotEmpty() {
    return id.isNotEmpty;
  }

  String get title => HtmlUnescape().convert(name);
  String get subtitle {
    String text = "";
    if(artists == null || artists!.isEmpty) {
      text = language!;
    } else {
      text = artists!.first.name;
    }
    return HtmlUnescape().convert("${album!.name} ◈ $text");
  }
  
  String get artistsName {
    String text = "";
    if(artists != null || artists!.isNotEmpty) text = artists!.first.name;
    return text;
  }
}