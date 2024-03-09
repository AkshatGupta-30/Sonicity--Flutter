import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sonicity/src/controllers/my_playlist_controller.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:super_string/super_string.dart';

class MyPlaylistAddSongTile extends StatelessWidget{
  final MyPlaylist playlist;
  final bool checkBoxValue;
  final MyPlaylistController controller;

  const MyPlaylistAddSongTile({super.key, required this.playlist, required this.checkBoxValue, required this.controller});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: SizedBox(
        width: 50, height: 50,
        child: ClipRRect(borderRadius: BorderRadius.circular(8), child: MyPlaylistLeadingCover(playlist: playlist, size: 50))
      ),
      title: Text(playlist.name.title(), style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400)),
      subtitle: Text("${playlist.songCount} Songs"),
      trailing: Checkbox(
        value: checkBoxValue,
        onChanged: (value) => (value!)
          ? controller.insertSong(playlist.name)
          : controller.deleteSong(playlist.name),
        activeColor: controller.settings.getAccent,
      ),
    );
  }
}

class MyPlaylistCell extends StatelessWidget {
  final MyPlaylist playlist;
  MyPlaylistCell({super.key, required this.playlist,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140, height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: MyPlaylistLeadingCover(playlist: playlist, size: 140),
            ),
          ),
          Gap(2),
          Text(
            playlist.name.title(), maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13),
          ),
          Text(
            "${playlist.songCount} Songs",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 11),
          )
        ],
      ),
    );
  }
}

class MyPlaylistLeadingCover extends StatelessWidget {
  final MyPlaylist playlist;
  final double size;
  const MyPlaylistLeadingCover({super.key, required this.playlist, required this.size});

  @override
  Widget build(BuildContext context) {
    if(int.parse(playlist.songCount) == 0) return _leadingAssetImage(playlist.image[0].medQuality);
    else return GridView.count(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2, 
      children: (int.parse(playlist.songCount) == 1)
        ? [
            _leadingNetworkImage(playlist.image[1].medQuality, playlist.image[0].medQuality),
            _leadingAssetImage(playlist.image[0].medQuality),
            _leadingAssetImage(playlist.image[0].medQuality),
            _leadingAssetImage(playlist.image[0].medQuality),
          ]
        : (int.parse(playlist.songCount) == 2)
          ? [
              _leadingNetworkImage(playlist.image[1].medQuality, playlist.image[0].medQuality),
              _leadingNetworkImage(playlist.image[2].medQuality, playlist.image[0].medQuality),
              _leadingAssetImage(playlist.image[0].medQuality),
              _leadingAssetImage(playlist.image[0].medQuality)
            ]
          : (int.parse(playlist.songCount) == 3)
            ? [
                _leadingNetworkImage(playlist.image[1].medQuality, playlist.image[0].medQuality),
                _leadingNetworkImage(playlist.image[2].medQuality, playlist.image[0].medQuality),
                _leadingNetworkImage(playlist.image[3].medQuality, playlist.image[0].medQuality),
                _leadingAssetImage(playlist.image[0].medQuality)
              ]
            : [
                _leadingNetworkImage(playlist.image[1].medQuality, playlist.image[0].medQuality),
                _leadingNetworkImage(playlist.image[2].medQuality, playlist.image[0].medQuality),
                _leadingNetworkImage(playlist.image[3].medQuality, playlist.image[0].medQuality),
                _leadingNetworkImage(playlist.image[4].medQuality, playlist.image[0].medQuality),
              ]
    );
  }

  Image _leadingAssetImage(String asset) => Image.asset(asset, width: size, height: size, fit: BoxFit.fill,);

  CachedNetworkImage _leadingNetworkImage(String url, String asset) {
    return CachedNetworkImage(
      imageUrl: url, width: size, height: size, fit: BoxFit.fill,
      placeholder: (_, __) => Image.asset(asset, width: size, height: size, fit: BoxFit.fill,),
      errorWidget: (_, __, ___) => Image.asset(asset, width: size, height: size, fit: BoxFit.fill,),
    );
  }
}