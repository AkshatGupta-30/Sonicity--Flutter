import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/pepicons.dart';
import 'package:iconify_flutter_plus/icons/raphael.dart';
import 'package:iconify_flutter_plus/icons/uis.dart';
import 'package:iconify_flutter_plus/icons/wpf.dart';
import 'package:sonicity/src/views/library/all_albums_view.dart';
import 'package:sonicity/src/views/library/all_artist_view.dart';
import 'package:sonicity/src/views/library/all_playlists_view.dart';
import 'package:sonicity/src/views/library/all_songs_view.dart';
import 'package:sonicity/src/views/library/recents_view.dart';
import 'package:sonicity/src/views/library/starred_view.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class LibraryView extends StatelessWidget {
  LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: DrawerButton().build(context), title: Text("Library")),
      body: BackgroundGradientDecorator(
        child: ListView(
          padding: EdgeInsets.all(15),
          physics: NeverScrollableScrollPhysics(),
          children: <Tile>[
            Tile(// * : All Songs
              onPressed: () => Get.to(() => AllSongsView()),
              icon: Pepicons.music_note_single,
              title: "All Songs",
            ),
            Tile(// * : Recents
              onPressed: () => Get.to(() => RecentsView()),
              icon: Raphael.history,
              title: "Recents",
            ),
            Tile(// * : Starred
              onPressed: () => Get.to(() => StarredView()),
              icon: Uis.favorite,
              title: "Starred",
            ),
            Tile(// * : Playlists
              onPressed: () => Get.to(() => AllPlaylistsView()),
              icon: Bx.bxs_playlist,
              title: "Playlists",
            ),
            Tile(// * : Album
              onPressed: () => Get.to(() => AllAlbumsView()),
              icon: Ic.baseline_album,
              title: "Album",
            ),
            Tile(// * : Artists
              onPressed: () => Get.to(() => AllArtistsView()),
              icon: Ion.md_microphone,
              title: "Artists",
            ),
            Tile(// * : Stats
              onPressed: () {},
              icon: Wpf.statistics,
              title: "Stats",
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final String title;
  
  Tile({super.key, required this.onPressed, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Iconify(
        icon, size: 30,
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      ),
      horizontalTitleGap: 30,
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
      splashColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 :Colors.grey.shade900,
    );
  }
}