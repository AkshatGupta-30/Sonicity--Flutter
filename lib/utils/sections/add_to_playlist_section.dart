import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/add_to_playlist_controller.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
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
          backgroundColor: Colors.black,
          appBar: _header(context, theme, controller: controller),
          body: BackgroundGradientDecorator(child: _body(theme, controller),),
          bottomSheet: _footer(context, controller, theme),
        );
      }
    );
  }

  AppBar _header(BuildContext context, ThemeData theme, {required AddToPlaylistController controller,}) {
    return AppBar(
      toolbarHeight: kToolbarHeight * 1.25,
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
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () => controller.sort(SortType.name, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.name, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.songCount, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Song Count Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.songCount, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Song Count Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.date, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Date Created Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.date, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_descending, label: "Date Created Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded, color: Theme.of(context).appBarTheme.actionsIconTheme!.color),
          position: PopupMenuPosition.under, color: Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Obx _body(ThemeData theme, AddToPlaylistController controller) {
    return Obx(() {
      if(controller.playlistCount.value == -1) return Lottie.asset("assets/lottie/gramophone2.json", animate: true, height: 40);
      if(controller.playlistCount.value != 0 && controller.playlists.isEmpty && controller.isSongPresent.isEmpty)
        return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 40);
      return ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: controller.playlists.length,
        itemBuilder: (context, index) {
          MyPlaylist playlist = controller.playlists[index];
          bool checkBoxValue = controller.isSongPresent[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (playlist.image.lowQuality == 'assets/images/myPlaylistCover/myPlaylistCover50x50.jpg')
                ? Image.asset(playlist.image.medQuality, width: 50, height: 50, fit: BoxFit.fill,)
                : CachedNetworkImage(
                  imageUrl: playlist.image.medQuality, width: 50, height: 50, fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset(playlist.image.medQuality, width: 50, height: 50, fit: BoxFit.fill,),
                  errorWidget: (context, url, error) => Image.asset(playlist.image.medQuality, width: 50, height: 50, fit: BoxFit.fill,),
                ),
            ),
            title: Text.rich(
              TextSpan(children: [
                TextSpan(text: playlist.name, style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400)),
                TextSpan(text: " ${playlist.songCount} Songs", style: theme.textTheme.labelSmall)
              ])
            ),
            subtitle: Text("${playlist.dateCreated.day.toString().padLeft(2, '0')}-${playlist.dateCreated.month.toString().padLeft(2, '0')}-${playlist.dateCreated.year}"),
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
        height: 40, width: double.maxFinite, alignment: Alignment.center,
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