import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:sonicity/src/audio/player_invoke.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/iconify.dart';

class ShuffleNPlay extends StatelessWidget {
  final List<Song> songs;
  ShuffleNPlay(this.songs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight, alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => playSongs(songs, index: 0, shuffle: true),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade200 : Colors.grey.shade800,
                border: Border.all(
                  color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300
                ),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                children: [
                  Text(
                    "Shuffle",
                    style: Theme.of(context).primaryTextTheme.headlineSmall,
                  ),
                  Iconify(
                    Ic.twotone_shuffle, size: 25,
                    color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,),
                ],
              ),
            ),
          ),
          Gap(5),
          Container(height: 30, width: 1, color: Colors.white38),
          Gap(5),
          InkWell(
            onTap: () => playSongs(songs, index: 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade200 : Colors.grey.shade800,
                border: Border.all(
                  color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Iconify(
                Ic.twotone_play_arrow, size: 27,
                color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}