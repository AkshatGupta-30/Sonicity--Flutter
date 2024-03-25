import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async => await AudioService.init(builder: () => MyAudioHandler());

abstract class AudioPlayerHandler implements AudioHandler {
  Future<void> setNewPlaylist(List<MediaItem> mediaItems, int index);
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  Future<void> removeQueueItemIndex(int index);
}

class MyAudioHandler extends BaseAudioHandler implements AudioPlayerHandler {
  /// The line `final player = AudioPlayer();` is creating an instance of the `AudioPlayer` class from
  /// the `just_audio` package. This `AudioPlayer` instance will be used to play audio in the audio
  /// service implementation.
  final player = AudioPlayer();
  
  /// The line `final playlist = ConcatenatingAudioSource(children: [], useLazyPreparation: true);` is
  /// creating a playlist of audio sources using the `ConcatenatingAudioSource` class from the
  /// `just_audio` package.
  /// 
  /// `ConcatenatingAudioSource` is a class from the `just_audio` package in Dart that
  /// allows you to create a playlist of audio sources by concatenating multiple audio
  /// sources together. It is used to combine multiple audio sources into a single
  /// source that can be played sequentially. The `children` parameter of
  /// `ConcatenatingAudioSource` takes a list of audio sources that will be played in
  /// the order they are provided. The `useLazyPreparation` parameter determines
  /// whether the audio sources are prepared in advance or lazily when needed for
  /// playback.
  final playlist = ConcatenatingAudioSource(children: [], useLazyPreparation: true);

  MyAudioHandler() {
    loadEmptyPlaylist();
    notifyAudioHandlerAboutPlaybackEvents();
    listenForDurationChanges();
    listenForCurrentSongIndexChanges();
    listenForSequenceStateChanges();
  }

  /// The function `loadEmptyPlaylist` asynchronously sets an empty playlist as the audio source for the
  /// player.
  Future<void> loadEmptyPlaylist() async {
    /// `await player.setAudioSource(playlist);` is setting the `playlist` as the audio source for the
    /// `player`. This means that the audio player (`player` instance) will play the audio content from
    /// the playlist (`ConcatenatingAudioSource` instance) that has been set. By setting the playlist as
    /// the audio source, the audio player is configured to play the audio tracks in the playlist in the
    /// order they are provided.
    await player.setAudioSource(playlist);
  }

  Future<void> notifyAudioHandlerAboutPlaybackEvents() async {
    player.playbackEventStream.listen((event) {
      final playing = player.playing;
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[player.loopMode]!,
        shuffleMode: player.shuffleModeEnabled
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  /// The function `listenForDurationChanges` listens for changes in the duration of the currently
  /// playing media item and updates the corresponding item in the queue.
  /// 
  /// Returns:
  ///   The `listenForDurationChanges` function returns a `Future<void>`.
  Future<void> listenForDurationChanges() async {
    /// The `player.durationStream.listen` method is setting up a listener to listen for changes in the
    /// duration of the currently playing media item. When the duration of the media item changes, the
    /// listener will be triggered, and the provided callback function will be executed. In this case,
    /// the callback function updates the duration of the corresponding media item in the queue by
    /// creating a new media item with the updated duration and replacing the old media item in the
    /// queue with the new one.
    player.durationStream.listen((duration) {
      var index = player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty || newQueue.length < index) return;
      if (player.shuffleModeEnabled) index = player.shuffleIndices!.indexOf(index);
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  /// This Dart function listens for changes in the current song index and updates the media item
  /// accordingly.
  Future<void> listenForCurrentSongIndexChanges() async {
    /// The `player.currentIndexStream.listen` method in the Dart code snippet is setting up a listener
    /// to listen for changes in the current index of the media item being played by the audio player.
    player.currentIndexStream.listen((index) {
      final pPlaylist = queue.value;
      if (index == null || pPlaylist.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(pPlaylist[index]);
    });
  }

  /// The `listenForSequenceStateChanges` function listens for changes in sequence state and adds the
  /// media items to a queue.
  Future<void> listenForSequenceStateChanges() async {
    /// The `player.sequenceStateStream.listen` method in the Dart code snippet is setting up a listener
    /// to listen for changes in the sequence state of the audio player. When the sequence state
    /// changes, the listener will be triggered, and the provided callback function will be executed. In
    /// this case, the callback function retrieves the effective sequence from the sequence state and
    /// extracts the media items from it. These media items are then added to the queue for playback.
    /// This mechanism allows for dynamically updating the queue based on the sequence state changes in
    /// the audio player.
    player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  /// The function `createAudioSource` creates an `UriAudioSource` from a `MediaItem` by parsing the URL
  /// from the extras and assigning the media item as a tag.
  UriAudioSource createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(Uri.parse(mediaItem.extras!['url'] as String), tag: mediaItem);
  }

  /// The function `createAudioSources` takes a list of `MediaItem` objects and creates a list of
  /// `UriAudioSource` objects based on the URLs stored in the `extras` field of each `MediaItem`.
  /// 
  /// Args:
  ///   mediaItems (List<MediaItem>): A list of `MediaItem` objects, which likely contain information
  /// about audio files such as their URLs.
  /// 
  /// Returns:
  ///   A list of `UriAudioSource` objects is being returned. Each `UriAudioSource` object is created by
  /// mapping over the `mediaItems` list and parsing the URL from the `extras` field of each `MediaItem`
  /// object. The `tag` property of each `UriAudioSource` object is set to the corresponding `MediaItem`
  /// object.
  List<UriAudioSource> createAudioSources(List<MediaItem> mediaItems) {
    return mediaItems
        .map((item) => AudioSource.uri(Uri.parse(item.extras!['url'] as String), tag: item))
        .toList();
  }

  /// The `addQueueItems` function adds a list of `MediaItem` objects to a playlist and updates the
  /// queue accordingly.
  /// 
  /// Args:
  ///   mediaItems (List<MediaItem>): A list of MediaItem objects that represent the media items to be
  /// added to the queue.
  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = createAudioSources(mediaItems);
    await playlist.addAll(audioSource);
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  /// This Dart function updates a media item in a queue based on its ID.
  /// 
  /// Args:
  ///   mediaItem (MediaItem): The `mediaItem` parameter in the `updateMediaItem` method represents the
  /// media item that needs to be updated in the queue. It is used to find the index of the media item
  /// in the queue based on its ID and then update the queue with the new media item at that index.
  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    final index = queue.value.indexWhere((item) => item.id == mediaItem.id);
    var dataArr = queue.value;
    dataArr[index] = mediaItem;
    queue.add(dataArr);
  }

  /// This function updates the queue by clearing the current playlist and adding new audio sources
  /// based on the provided list of media items.
  /// 
  /// Args:
  ///   queue (List<MediaItem>): The `queue` parameter is a list of `MediaItem` objects, which likely
  /// represent media items such as songs or audio tracks that need to be added to a playlist or queue
  /// for playback.
  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    await playlist.clear();
    await playlist.addAll(createAudioSources(queue));
  }

  /// The function `removeQueueItemAt` removes items from a playlist queue at the specified index and
  /// updates the queue.
  /// 
  /// Args:
  ///   index (int): The `index` parameter in the `removeQueueItemAt` method represents the position of
  /// the item in the playlist that you want to remove. It is an integer value indicating the index of
  /// the item to be removed from the playlist.
  @override
  Future<void> removeQueueItemAt(int index) async {
    await playlist.removeRange(0, index);
    final newQueue = queue.value..clear();
    queue.add(newQueue);
  }

  /// This function overrides the play method to play the audio using the player asynchronously in Dart.
  @override
  Future<void> play() async => await player.play();

  /// This function overrides the pause method to pause the player asynchronously.
  @override
  Future<void> pause() async => await player.pause();

  /// This function overrides the seek method to update the player's position asynchronously in Dart.
  /// 
  /// Args:
  ///   position (Duration): The `position` parameter in the `seek` method represents the time duration
  /// to which the player should seek within the media. It specifies the new position within the media
  /// where playback should resume or start from.
  @override
  Future<void> seek(Duration position) async => player.seek(position);

  /// This Dart function skips to a specific item in a queue, considering shuffle mode if enabled.
  /// 
  /// Args:
  ///   index (int): The `index` parameter represents the position of the item in the queue that the
  /// player should skip to. It is an integer value that indicates the index of the item in the queue.
  /// 
  /// Returns:
  ///   If the `index` is less than 0 or greater than or equal to the length of the queue, then `null`
  /// is being returned.
  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (player.shuffleModeEnabled) {
      index = player.shuffleIndices![index];
    }
    player.seek(Duration.zero, index: index);
  }

  /// This function overrides the skipToNext method to seek to the next position in the player
  /// asynchronously.
  @override
  Future<void> skipToNext() async => player.seekToNext();

  /// This function overrides the skipToPrevious method to seek to the previous track in a media player
  /// asynchronously.
  @override
  Future<void> skipToPrevious() async => player.seekToPrevious();

  /// The function `setRepeatMode` sets the repeat mode of an audio player based on the provided
  /// `AudioServiceRepeatMode`.
  /// 
  /// Args:
  ///   repeatMode (AudioServiceRepeatMode): The `repeatMode` parameter in the `setRepeatMode` function
  /// is of type `AudioServiceRepeatMode`. It is used to determine the repeat mode for audio playback.
  /// The function sets the appropriate loop mode in the player based on the value of `repeatMode`.
  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        player.setLoopMode(LoopMode.all);
        break;
    }
  }

  /// The function `setShuffleMode` toggles shuffle mode in an audio player based on the provided
  /// shuffle mode.
  /// 
  /// Args:
  ///   shuffleMode (AudioServiceShuffleMode): The `shuffleMode` parameter in the `setShuffleMode`
  /// function is of type `AudioServiceShuffleMode`. It is used to determine the shuffle mode for the
  /// audio player. If the `shuffleMode` is set to `AudioServiceShuffleMode.none`, the function disables
  /// shuffle mode
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      player.setShuffleModeEnabled(false);
    } else {
      player.shuffle();
      player.setShuffleModeEnabled(true);
    }
  }

  /// The customAction function checks if the input name is 'dispose' and if so, disposes the player and
  /// stops playback.
  /// 
  /// Args:
  ///   name (String): The `name` parameter is a string that represents the action to be performed. In
  /// this case, it is used to determine if the action is to dispose of a resource.
  ///   extras (Map<String, dynamic>): The `extras` parameter in the `customAction` method is a Map with
  /// String keys and dynamic values. It is an optional parameter, meaning it can be omitted when
  /// calling the method. This parameter allows you to pass additional information or data to the method
  /// if needed.
  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if(name == 'dispose') {
      await player.dispose();
      super.stop();
    }
  }

  /// The `stop` function stops the audio player, updates the playback state to idle, and then calls the
  /// superclass `stop` function.
  /// 
  /// Returns:
  ///   The `stop()` method is returning a `Future<void>`.
  @override
  Future<void> stop() async {
    await player.stop();
    playbackState.add(playbackState.value.copyWith(processingState: AudioProcessingState.idle));
    return super.stop();
  }

  /// The `moveQueueItem` function in Dart moves an item in a playlist from the current index to a new
  /// index.
  /// 
  /// Args:
  ///   currentIndex (int): The `currentIndex` parameter represents the current index of the item in the
  /// queue that you want to move.
  ///   newIndex (int): The `newIndex` parameter represents the new position where the queue item will
  /// be moved to in the playlist.
  @override
  Future<void> moveQueueItem(int currentIndex, int newIndex) async => await playlist.move(currentIndex, newIndex);

  /// This function removes an item from a playlist at a specific index.
  /// 
  /// Args:
  ///   index (int): The `index` parameter in the `removeQueueItemIndex` method represents the position
  /// of the item in the playlist that you want to remove. It is an integer value that indicates the
  /// index of the item to be removed from the playlist.
  @override
  Future<void> removeQueueItemIndex(int index) async => await playlist.removeAt(index);

  /// The function `setNewPlaylist` sets a new playlist of media items in a music player, updating the
  /// queue and audio source accordingly.
  /// 
  /// Args:
  ///   mediaItems (List<MediaItem>): A list of MediaItem objects representing the new playlist to be
  /// set.
  ///   index (int): The `index` parameter in the `setNewPlaylist` method represents the position in the
  /// playlist where the new media items should be inserted. It is an integer value that indicates the
  /// index at which the new media items should be added in the playlist.
  @override
  Future<void> setNewPlaylist(List<MediaItem> mediaItems, int index) async {
    if (!Platform.isAndroid) await player.stop();

    int getCount = queue.value.length;
    await playlist.removeRange(0, getCount);
    final audioSource = createAudioSources(mediaItems);
    await playlist.addAll(audioSource);
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
    await player.setAudioSource(playlist, initialIndex: index, initialPosition: Duration.zero);
  }
}