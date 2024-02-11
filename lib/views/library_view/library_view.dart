// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sonicity/views/library_view/storage_view.dart';

class LibraryView extends StatelessWidget {
  LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text("Library"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          physics: NeverScrollableScrollPhysics(),
          children: [
            Tile(// * : All Songs
              onPressed: () {},
              icon: LineAwesomeIcons.music,
              title: "All Songs",
            ),
            Tile(// * : Recents
              onPressed: () {},
              icon: Icons.history,
              title: "Recents",
            ),
            Tile(// * : Favorities
              onPressed: () {},
              icon: Icons.favorite_border,
              title: "Favorites",
            ),
            Tile(// * : My Storage
              onPressed: () => Get.to(() => StorageView()),
              icon: Icons.folder_outlined,
              title: "My Storage",
            ),
            Tile(// * : Playlists
              onPressed: () {},
              icon: Icons.playlist_play_rounded,
              title: "Playlists",
            ),
            Tile(// * : Album
              onPressed: () {},
              icon: Icons.album_rounded,
              title: "Album",
            ),
            Tile(// * : Artsists
              onPressed: () {},
              icon: Icons.person,
              title: "Artists",
            ),
            Tile(// * : Genres
              onPressed: () {},
              icon: FontAwesomeIcons.tags,
              title: "Genres",
            ),
            Tile(// * : Stats
              onPressed: () {},
              icon: Icons.auto_graph,
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
  final IconData icon;
  final String title;
  
  Tile({super.key, required this.onPressed, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, size: 30),
      horizontalTitleGap: 30,
      title: Text(title),
      titleTextStyle: TextStyle(fontSize: 20),
      splashColor: Colors.grey.shade900,
      iconColor: Colors.white,
    );
  }
}