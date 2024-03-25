import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
import 'package:super_string/super_string.dart';

class MyPlaylistDetailsView extends StatelessWidget {
  MyPlaylistDetailsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: MyPlaylistDetailController(Get.arguments),
              builder: (controller) => Obx(() {
                if(controller.playlist.value.songs == null) {
                  return Center(
                    child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                  );
                }
                return CustomScrollView(
                  slivers: [
                    _appBar(context, media, controller),
                    _summaryHeader(context, controller),
                    _playlistSongs(controller.playlist.value),
                  ],
                );
              })
            ),
          ),
          MiniPlayerView()
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context, Size media, MyPlaylistDetailController controller) {
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      leading: BackButton(),
      expandedHeight: 360,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
        title: SizedBox(
          width: media.width/1.4,
          child: Text(
            controller.playlist.value.name.title(), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        background: Stack(
          children: [
            MyPlaylistLeadingCover(playlist: controller.playlist.value, size: 0),
            Container(
              width: media.width, height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: (Theme.of(context).brightness == Brightness.light)
                      ? [Colors.white.withOpacity(0), Colors.white.withOpacity(0.75)]
                      : [Colors.black.withOpacity(0), Colors.black.withOpacity(0.75)],
                  begin: Alignment.center, end: Alignment.bottomCenter,
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverPinnedHeader _summaryHeader(BuildContext context, MyPlaylistDetailController controller) {
    return SliverPinnedHeader(
      child: Container(
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
        child: Row( 
          children: [
            Gap(20),
            Text("${controller.importedPlaylist.songs!.length} Songs", style: Theme.of(context).textTheme.bodyLarge),
            Spacer(),
            ShuffleNPlay(controller.playlist.value.songs!),
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
                    onTap: () => controller.sort(SortType.duration, Sort.asc),
                    child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Duration Asc")
                  ),
                  PopupMenuItem(
                    onTap: () => controller.sort(SortType.duration, Sort.dsc),
                    child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Duration Desc")
                  ),
                  PopupMenuItem(
                    onTap: () => controller.sort(SortType.year, Sort.asc),
                    child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Year Asc")
                  ),
                  PopupMenuItem(
                    onTap: () => controller.sort(SortType.year, Sort.dsc),
                    child: PopUpButtonRow(icon: Mdi.sort_calendar_descending, label: "Year Desc")
                  ),
                ];
              },
              icon: Iconify(MaterialSymbols.sort_rounded,),
              position: PopupMenuPosition.under,
              color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            Gap(10)
          ],
        ),
      ),
    );
  }

  SliverPadding _playlistSongs(MyPlaylist playlist) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      sliver: SliverList.builder(
        itemCount: playlist.songs!.length,
        itemBuilder: (context, index) {
          Song song = playlist.songs![index];
          return SongTile(song);
        },
      ),
    );
  }
}