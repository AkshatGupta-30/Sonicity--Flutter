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
    return MediaItem(
      id: song.id,
      album: song.album!.name,
      artist: song.artistsName,
      duration: Duration(
        seconds: int.parse(song.duration!),
      ),
      title: song.title,
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
      },
    );
  }

  static Song toSong(MediaItem song) {
    return Song(
      id: song.id, name: song.title,
      image: ImageUrl.empty(),
      downloadUrl: DownloadUrl.empty(),
      hasLyrics: false
    );
  }
}