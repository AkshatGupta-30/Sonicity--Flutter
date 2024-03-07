import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/add_to_playlist_controller.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class AddToPlaylistDialog extends StatelessWidget {
  final Song song;
  AddToPlaylistDialog(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder(
      init: AddToPlaylistController(song),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _header(context, theme, controller: controller),
          body: BackgroundGradientDecorator(child: _body(controller)),
          bottomSheet: _footer(context, controller, theme),
        );
      }
    );
  }

  AppBar _header(BuildContext context, ThemeData theme, {required AddToPlaylistController controller,}) {
    return AppBar(
      toolbarHeight: kToolbarHeight * 1.25,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: SizedBox(), leadingWidth: 0,
      centerTitle: false,
      title: Text("Add to Playlist",),
      titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(fontWeight: FontWeight.w300),
      actions: [
        Tooltip(
          message: "New playlist",
          child: CircleAvatar(
            radius: 22, backgroundColor: Colors.transparent,
            child: InkWell(
              onTap: () => _newPlaylistDialog(context, theme, controller: controller),
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Iconify(Ic.twotone_playlist_add_circle, size: 30,),
              ),
            ),
          ),
        ),
        Tooltip(
          message: "Sort Playlist",
          child: CircleAvatar(
            radius: 22, backgroundColor: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Iconify(MaterialSymbols.sort_rounded, size: 30,),
              ),
            ),
          ),
        ),
        Gap(10)
      ],
      bottom: PreferredSize(
        preferredSize: Size(double.maxFinite, 20),
        child: Text("TODO Search Playlist", style: TextStyle(color: Colors.red),)
      ),
    );
  }

  Future<dynamic> _newPlaylistDialog(BuildContext context, ThemeData theme, {required AddToPlaylistController controller,}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        backgroundColor: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
        title: Text("New Playlist"),
        titleTextStyle: theme.textTheme.labelLarge,
        content: TextField(
          controller: controller.textController,
          cursorColor: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
          style: TextStyle(color: (theme.brightness == Brightness.light) ?Colors.black : Colors.white,),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1),),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 3),),
            hintText: "Playlist Name"
          ),
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

  Obx _body(AddToPlaylistController controller) {
    return Obx(() {
      if(controller.playlistCount.value == -1) return Lottie.asset("assets/lottie/gramophone2.json", animate: true, height: 40);
      if(controller.playlistCount.value != 0 && controller.playlists.isEmpty)
        return Lottie.asset("assets/lottie/gramophone2.json", animate: true, height: 40);
      return ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: controller.playlists.length,
        itemBuilder: (context, index) {
          Playlist playlist = controller.playlists[index];
          bool checkBoxValue = controller.isSongPresent[index];
          DateTime dateCreated = DateTime.parse(controller.dateCreated[index]);
          String formattedDate = "${dateCreated.day.toString().padLeft(2, '0')}-${dateCreated.month.toString().padLeft(2, '0')}-${dateCreated.year}";
          return ListTile(
            title: Text(playlist.name),
            subtitle: Text("${playlist.songCount} Songs ◈ $formattedDate"),
            trailing: Checkbox(
              value: checkBoxValue,
              onChanged: (value) => (value!)
                ? controller.insertSong(playlist.name)
                : controller.deleteSong(playlist.name),
              activeColor: controller.settings.getAccent,
            ),
          );
        },
      );
    });
  }

  _footer(BuildContext context, AddToPlaylistController controller, ThemeData theme) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40, width: 75, alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: controller.settings.getAccent,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Text("Done", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
      ),
    );
  }
}