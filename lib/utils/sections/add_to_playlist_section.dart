import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:sonicity/src/controllers/add_to_playlist_controller.dart';
import 'package:sonicity/src/models/playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

class AddToPlaylistSheet extends StatelessWidget {
  final Song song;
  AddToPlaylistSheet(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder(
      init: AddToPlaylistController(song),
      builder: (controller) {
        return SizedBox(
          height: 400,
          child: Scaffold(
            body: BackgroundGradientDecorator(
              child: Column(
                children: [
                  _header(context, theme, controller: controller,),
                  _body(controller),
                  _footer(context, controller, theme)
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Obx _body(AddToPlaylistController controller) {
    return Obx(() => SizedBox(
      height: 400 - kToolbarHeight - 60,
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: controller.playlists.length,
        itemBuilder: (context, index) {
          Playlist playlist = controller.playlists[index];
          bool checkBoxValue = controller.isSongPresent[index];
          return ListTile(
            onTap: () => controller.insertSong(playlist.name),
            title: Text(playlist.name),
            subtitle: Text("${playlist.songCount} Songs"),
            trailing: Checkbox(
              value: checkBoxValue,
              onChanged: (value) => (value!)
                ? controller.insertSong(playlist.name)
                : controller.deleteSong(playlist.name),
              activeColor: controller.settings.getAccent,
            ),
          );
        },
      ),
    ));
  }

  AppBar _header(BuildContext context, ThemeData theme, {required AddToPlaylistController controller,}) {
    return AppBar(
      leading: SizedBox(), leadingWidth: 0,
      centerTitle: false,
      title: Text("Add to Playlist",),
      titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(fontWeight: FontWeight.w300),
      actions: [
        GestureDetector(
          onTap: () => _newPlaylistDialog(context, theme, controller: controller,),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: controller.settings.getAccent,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Iconify(Ic.twotone_playlist_add_circle,),
                Gap(2),
                Text("New Playlist", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal))
              ],
            ),
          ),
        ),
        Gap(10)
      ],
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
              controller.newPlaylist();
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

  Center _footer(BuildContext context, AddToPlaylistController controller, ThemeData theme) {
    return Center(
      child: GestureDetector(
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
      ),
    );
  }
}