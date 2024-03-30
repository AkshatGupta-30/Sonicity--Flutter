import 'package:audio_service/audio_service.dart';
import 'package:sonicity/src/models/models.dart';

class MediaItemConverter {
  static MediaItem toMediaItem(
    Song song, {
      bool addedByAutoplay = false,
      bool autoplay = true,
      String? playlistBox
    }
  ) {
    List<Map<String, dynamic>> artists = [];
    if(song.artists != null) {
      for (var artist in song.artists!) artists.add(artist.toMap());
    }

    return MediaItem(
      id: song.id,
      album: song.album!.name,
      artist: song.artistsName,
      duration: Duration(seconds: int.parse(song.duration!)),
      title: song.name,
      displayTitle: song.title,
      displaySubtitle: song.subtitle,
      artUri: Uri.parse(song.image.highQuality),
      genre: song.language ?? '',
      extras: {
        'user_id': song.id,
        'url': song.downloadUrl.link,
        'album_id': song.album!.id,
        'addedByAutoplay': addedByAutoplay,
        'autoplay': autoplay,
        'playlistBox': playlistBox,
        'album': song.album!.toMap(),
        'artists': artists,
        'duration': song.duration ?? '',
        'year': song.year ?? '',
        'releaseDate': song.releaseDate ?? '',
        'language': song.language ?? '',
        'image': song.image.toMap(),
        'downloadUrl':  song.downloadUrl.toMap(),
        'hasLyrics': song.hasLyrics
      },
    );
  }

  static Song toSong(MediaItem mediaItem) {
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
}