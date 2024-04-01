import 'package:cached_network_image/cached_network_image.dart';
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

class PlaylistDetailsView extends StatelessWidget {
  PlaylistDetailsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: PlaylistDetailController(Get.arguments),
              builder: (controller) => Obx(() {
                Playlist playlist = controller.playlist.value;
                if(playlist.isEmpty()) {
                  return Center(
                    child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                  );
                }
                return CustomScrollView(
                  slivers: [
                    _appBar(context, media, playlist, controller),
                    _summaryHeader(context, playlist, controller),
                    _playlistSongs(playlist),
                  ],
                );
              }
            )),
          ),
          MiniPlayerView()
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context, Size media, Playlist playlist, PlaylistDetailController controller) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      leading: BackButton(),
      expandedHeight: 360,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        title: SizedBox(
          width: media.width/1.4,
          child: Text(
            playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
        ),
        background: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: playlist.image.highQuality, fit: BoxFit.fill,
              width: double.maxFinite, height: double.maxFinite,
              placeholder: (_,__) {
                return Image.asset("assets/images/playlistCover/playlistCover500x500.jpg", fit: BoxFit.fill);
              },
              errorWidget: (_,__,___) {
                return Image.asset("assets/images/playlistCover/playlistCover500x500.jpg", fit: BoxFit.fill);
              },
            ),
            Container(
              width: media.width, height: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: (theme.brightness == Brightness.light)
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

  SliverPinnedHeader _summaryHeader(BuildContext context, Playlist playlist, PlaylistDetailController controller) {
    final theme = Theme.of(context);
    return SliverPinnedHeader(
      child: Container(
          color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          child: Row( 
            children: [
              Gap(20),
              Text("${playlist.songs!.length} Songs", style: theme.textTheme.bodyLarge),
              Spacer(),
              ShuffleNPlay(controller.playlist.value.songs!, queueLabel: 'Playlist - ${playlist.name}',),
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
                color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              Gap(10)
            ],
          ),
        ),
    );
  }

  SliverPadding _playlistSongs(Playlist playlist) {
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