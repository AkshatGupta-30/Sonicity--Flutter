import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:sonicity/src/controllers/my_playlist_controller.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:sonicity/src/views/details/my_playlist_details_view.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:super_string/super_string.dart';

class MyPlaylistCell extends StatelessWidget {
  final MyPlaylist playlist;
  MyPlaylistCell({super.key, required this.playlist,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (int.parse(playlist.songCount) == 0) ? null : () => Get.to(() => MyPlaylistDetailsView(), arguments: playlist),
      child: Container(
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
      ),
    );
  }
}

class MyPlaylistViewTile extends StatelessWidget {
  final MyPlaylistController controller;
  final int index;
  const MyPlaylistViewTile({super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    MyPlaylist playlist = (controller.searching.value)
      ? controller.searchResults[index]
      : controller.playlists[index];
    return ListTile(
      onTap: (int.parse(playlist.songCount) == 0) ? null : () => Get.to(() => MyPlaylistDetailsView(), arguments: playlist),
      contentPadding: EdgeInsets.only(left: 16),
      leading: SizedBox(
        width: 60, height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: MyPlaylistLeadingCover(playlist: playlist, size: 0,)
        )
      ),
      title: Text(playlist.name.title(), style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
      subtitle: Text("${playlist.songCount} Songs"),
      trailing: InkWell(
        onTap: () => controller.deletePlaylist(playlist),
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () => showDialog(
                    context: context, barrierDismissible: true, useRootNavigator: true,
                    builder: (ctx) => RenamePlaylistDialog(controller, playlistName: playlist.name),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: PopUpButtonRow(icon: MaterialSymbols.drive_file_rename_outline_outline_rounded, label: "Rename"),
                ),
                PopupMenuItem(
                  onTap: () => controller.deletePlaylist(playlist),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: PopUpButtonRow(icon: MaterialSymbols.delete_outline_rounded, label: "Delete"),
                ),
              ];
            },
            padding: EdgeInsets.zero,
            icon: Iconify(
              Ic.sharp_more_vert, size: 32,
              color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
            ),
          ),
        ),
      )
    );
  }
}

class MyPlaylistMergeTile extends StatelessWidget {
  final MyPlaylistController controller;
  final int index;
  const MyPlaylistMergeTile({super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    MyPlaylist playlist = (controller.searching.value)
      ? controller.searchResults[index]
      : controller.playlists[index];
    bool isMerging = controller.isMerging[index];
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      secondary: SizedBox(
        width: 60, height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: MyPlaylistLeadingCover(playlist: playlist, size: 0,)
        )
      ),
      title: Text(playlist.name.title(), style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
      subtitle: Text("${playlist.songCount} Songs"),
      value: isMerging,
      onChanged: (value) => controller.addToMerge(index, value!),
      activeColor: controller.settings.getAccent,
    );
  }
}

class MyPlaylistAddSongTile extends StatelessWidget{
  final int index;
  final MyPlaylistController controller;
  MyPlaylistAddSongTile({super.key, required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MyPlaylist playlist = (controller.searching.value)
      ? controller.searchResults[index]
      : controller.playlists[index];
    bool checkBoxValue = (controller.searching.value)
      ? controller.searchIsSongPresent[index]
      : controller.isSongPresent[index];
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

class NewPlaylistDialog extends StatelessWidget {
  final MyPlaylistController controller;
  const NewPlaylistDialog(this.controller, {super.key,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Get.find<SettingsController>();
    return GestureDetector(
      onTap: () => controller.searchPlaylistFocus.unfocus(),
      child: AlertDialog(
        elevation: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        backgroundColor: (theme.brightness == Brightness.light) ? Colors.white : Colors.black,
        shadowColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
        title: Text("New Playlist"),
        titleTextStyle: theme.textTheme.labelLarge,
        content: TextField(
          controller: controller.newPlaylistTextController,
          cursorColor: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
          style: TextStyle(color: (theme.brightness == Brightness.light) ?Colors.black : Colors.white,),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccentDark, width: 2),),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccent, width: 3),),
            hintText: "Playlist Name"
          ),
          onTap: () => controller.newPlaylistTfActive.value = true,
          focusNode: controller.newPlaylistFocus,
          onTapOutside: (event) {
            controller.newPlaylistFocus.unfocus();
            controller.newPlaylistTfActive.value = false;
          },
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text("Cancel", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              controller.createPlaylist();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: controller.settings.getAccent,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text("Create", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
            ),
          )
        ]
      ),
    );
  }
}

class RenamePlaylistDialog extends StatelessWidget {
  final String playlistName;
  final MyPlaylistController controller;
  const RenamePlaylistDialog(this.controller, {super.key, required this.playlistName,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Get.find<SettingsController>();
    return GestureDetector(
      onTap: () => controller.searchPlaylistFocus.unfocus(),
      child: AlertDialog(
        elevation: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        backgroundColor: (theme.brightness == Brightness.light) ? Colors.white : Colors.black,
        shadowColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
        title: Text("Rename - $playlistName"),
        titleTextStyle: theme.textTheme.labelLarge,
        content: TextField(
          controller: controller.renamePlaylistTextController,
          cursorColor: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
          style: TextStyle(color: (theme.brightness == Brightness.light) ?Colors.black : Colors.white,),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccentDark, width: 2),),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccent, width: 3),),
            hintText: "New Name"
          ),
          onTap: () => controller.renamePlaylistTfActive.value = true,
          focusNode: controller.renamePlaylistFocus,
          onTapOutside: (event) {
            controller.renamePlaylistFocus.unfocus();
            controller.renamePlaylistTfActive.value = false;
          },
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text("Cancel", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              controller.renamePlaylist(playlistName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: controller.settings.getAccent,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text("Done", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
            ),
          )
        ]
      ),
    );
  }
}