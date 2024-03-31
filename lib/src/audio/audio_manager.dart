import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/utils/contants/constants.dart';

/// The PlayButtonNotifier class is a ValueNotifier that manages the state of a play button with
/// possible states of paused, playing, and loading.
enum ButtonState {paused, playing, loading,}
class PlayButtonNotifier extends ValueNotifier<ButtonState> {
  PlayButtonNotifier() : super(_initialValue);
  static const _initialValue = ButtonState.paused;
}

/// The `ProgressNotifier` class in Dart represents a value notifier for managing the state of a
/// progress bar with current, buffered, and total durations.
class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;
  ProgressBarState({required this.current, required this.buffered, required this.total});
}

class ProgressNotifier extends ValueNotifier<ProgressBarState> {
  ProgressNotifier() : super(_initialValue);
  static final _initialValue = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}

/// The `RepeatButtonNotifier` class in Dart is a `ValueNotifier` that manages the state of a repeat
/// button with options for off, repeat song, and repeat playlist.
enum RepeatState {off, repeatSong, repeatPlaylist,}
class RepeatButtonNotifier extends ValueNotifier<RepeatState> {
  RepeatButtonNotifier() : super(_initialValue);
  static const _initialValue = RepeatState.off;

  void nextState() {
    final next = (value.index + 1) % RepeatState.values.length;
    value = RepeatState.values[next];
  }
}

class AudioManager {
  final currentSongNotifier = ValueNotifier<MediaItem?>(null);
  final playbackStatNotifier = ValueNotifier<AudioProcessingState>(AudioProcessingState.idle);
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final audioHandler = getIt<AudioHandler>();

  void init() async {
    listenToChangeInPlaylist();
    listenToPlayBackState();
    listenToCurrentPosition();
    listenToBufferedPosition();
    listenToTotalPosition();
    listenToChangesInSong();
  }

  /// The `listenToChangeInPlaylist` function listens for changes in the playlist and updates the UI
  /// accordingly.
  void listenToChangeInPlaylist() {
    /// The `audioHandler.queue.listen` method is setting up a listener to listen for changes in the
    /// playlist of the audio handler. When the playlist changes, the provided callback function will be
    /// executed, allowing you to update the UI or perform any necessary actions based on the new
    /// playlist content.
    audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongNotifier.value = null;
      } else {
        playlistNotifier.value = playlist;
      }
      updateSkipButton();
    });
  }

  /// The function `updateSkipButton` checks if the current media item is the first or last in the
  /// playlist and updates corresponding notifier values.
  void updateSkipButton() {
    final mediaItem = audioHandler.mediaItem.value;
    final playlist = audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  /// The function `listenToPlayBackState` listens to the playback state of an audio player and updates
  /// the UI accordingly based on the processing state and playing status.
  void listenToPlayBackState() {
    /// The `audioHandler.playbackState.listen` method is setting up a listener to listen for changes in
    /// the playback state of an audio player. When the playback state changes, the provided callback
    /// function will be executed, allowing you to update the UI or perform any necessary actions based
    /// on the new playback state, such as updating the playing status or processing state of the audio
    /// player.
    audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      playbackStatNotifier.value = processingState;
      playbackStatNotifier.value = processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        audioHandler.seek(Duration.zero);
        audioHandler.pause();
      }
    });
  }

  /// The `listenToCurrentPosition` function updates the progress notifier with the current audio
  /// position.
  void listenToCurrentPosition() {
    /// `AudioService.position.listen` is setting up a listener to listen for changes in the current
    /// position of the audio being played. When the position changes, the provided callback function
    /// will be executed, allowing you to update the UI or perform any necessary actions based on the
    /// new position of the audio.
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  /// The function `listenToBufferedPosition` updates the progress bar state with the buffered position
  /// during audio playback.
  void listenToBufferedPosition() {
    /// The `audioHandler.playbackState.listen` method is setting up a listener to listen for changes in
    /// the playback state of an audio player. When the playback state changes, the provided callback
    /// function will be executed. This allows you to update the UI or perform any necessary actions
    /// based on the new playback state, such as updating the playing status or processing state of the
    /// audio player.
    audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total
      );
    });
  }

  /// The `listenToTotalPosition` function updates the progress bar state with the total duration of the
  /// media item being played.
  void listenToTotalPosition() {
    /// The `audioHandler.mediaItem.listen` method sets up a listener to listen for changes in the
    /// currently playing media item. When the media item changes, the provided callback function will
    /// be executed, allowing you to update the UI or perform any necessary actions based on the new
    /// media item being played.
    audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  /// The `listenToChangesInSong` function listens for changes in the current song being played and
  /// updates the UI accordingly.
  void listenToChangesInSong() {
    /// The `audioHandler.mediaItem.listen` method sets up a listener to listen for changes in the
    /// currently playing media item. When the media item changes, the provided callback function will
    /// be executed, allowing you to update the UI or perform any necessary actions based on the new
    /// media item being played.
    audioHandler.mediaItem.listen((mediaItem) async {
      currentSongNotifier.value = mediaItem;
      updateSkipButton();
    });
  }

  /// The `play` function in Dart calls the `play` method of the `audioHandler` object.
  void play() => audioHandler.play();
  /// The `pause()` function calls the `pause()` method on the `audioHandler` object.
  void pause() => audioHandler.pause();
  /// The `seek` function in Dart is used to seek to a specific position in an audio file using the
  /// provided `Duration` parameter.
  /// 
  /// Args:
  ///   position (Duration): The `position` parameter represents the time duration to which the audio
  /// should seek or jump to in the audio player. It specifies the point in the audio track where
  /// playback should start from or skip to.
  void seek(Duration position) => audioHandler.seek(position);
  /// The `previous()` function in Dart skips to the previous audio track using the `audioHandler`.
  void previous() => audioHandler.skipToPrevious();
  /// The `next()` function in Dart skips to the next audio track using the `audioHandler`.
  void next() => audioHandler.skipToNext();

  Future<void> playAS() async => await audioHandler.play();

  Future<void> updateQueue(List<MediaItem> queue) async => await audioHandler.updateQueue(queue);

  Future<void> updateMediaItem(MediaItem mediaItem) async => await audioHandler.updateMediaItem(mediaItem);

  Future<void> moveMediaItem(int currentIndex, int newIndex) async {
    return await (audioHandler as AudioPlayerHandler)
        .moveQueueItem(currentIndex, newIndex);
  }

  Future<void> removeQueueItemAt(int index) async {
    return await (audioHandler as AudioPlayerHandler)
        .removeQueueItemIndex(index);
  }

  Future<void> customAction(String name) async => await audioHandler.customAction(name);

  Future<void> skipToQueueItem(int index) async => await audioHandler.skipToQueueItem(index);

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        repeatButtonNotifier.value = RepeatState.off;
        break;
      case AudioServiceRepeatMode.one:
        repeatButtonNotifier.value = RepeatState.repeatSong;
        break;
      case AudioServiceRepeatMode.group:
        break;
      case AudioServiceRepeatMode.all:
        repeatButtonNotifier.value = RepeatState.repeatPlaylist;
        break;
    }
    audioHandler.setRepeatMode(repeatMode);
  }

  void shuffle() async {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> setShuffleMode(AudioServiceShuffleMode value) async {
    isShuffleModeEnabledNotifier.value = value == AudioServiceShuffleMode.all;
    return audioHandler.setShuffleMode(value);
  }

  Future<void> add(MediaItem mediaItem) async => audioHandler.addQueueItem(mediaItem);

  Future<void> adds(List<MediaItem> mediaItems, int index) async {
    if(mediaItems.isEmpty) return;
    await (audioHandler as MyAudioHandler).setNewPlaylist(mediaItems, index);
  }

  void remove(){
    final lastIndex = audioHandler.queue.value.length - 1;
    if(lastIndex < 0) return;
    audioHandler.removeQueueItemAt(lastIndex);
  }

  Future<void> removeAll() async {
    final lastIndex = audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() => audioHandler.customAction('dispose');

  Future<void> stop() async {
    await audioHandler.stop();
    await audioHandler.seek(Duration.zero);
    currentSongNotifier.value = null;
    await removeAll();
    await Future.delayed(const Duration(milliseconds: 300));
  }
}