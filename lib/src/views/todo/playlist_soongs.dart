import 'package:flutter/material.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';

class PlaylistSongs extends StatelessWidget {
  final List<Song> songs;
  const PlaylistSongs({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) => SongsTile(songs[index]),
      ),
    );
  }
}