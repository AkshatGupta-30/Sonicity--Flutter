// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonicity/src/models/playlist.dart';

class PlaylistCell extends StatelessWidget {
  final Playlist playlist;
  PlaylistCell({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: playlist.image.standardQuality,
              width: 140, height: 140, fit: BoxFit.fill,
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  width: 140, height: 140, fit: BoxFit.fill,
                );
              },
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/appLogo150x150.png",
                  width: 140, height: 140, fit: BoxFit.fill,
                );
              },
            ),
          ),
          SizedBox(height: 2,),
          Text(
            playlist.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            "${playlist.songCount} Songs",
            style: TextStyle(color: Colors.grey,  fontSize: 11),
          )
        ],
      ),
    );
  }
}