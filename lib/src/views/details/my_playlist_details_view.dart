import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/my_playlist_detail_controller.dart';
import 'package:sonicity/src/models/my_playlist.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/my_playlist_widget.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';
import 'package:super_string/super_string.dart';

class MyPlaylistDetailsView extends StatelessWidget {
  MyPlaylistDetailsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: BackgroundGradientDecorator(
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
                _playlistSongs(controller.playlist.value),
              ],
            );
          })
        ),
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context, Size media, MyPlaylistDetailController controller) {
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      leading: BackButton(),
      expandedHeight: 400,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 20, right: 20, bottom: 75),
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
              width: media.width, height: 420,
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
      actions: [
        SpiderReport(color: Colors.redAccent),
        Gap(10),
      ],
      bottom: PreferredSize(
        preferredSize: Size(double.maxFinite, 60),
        child: Container(
          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          child: Row( 
            children: [
              Gap(20),
              Text("${controller.importedPlaylist.songs!.length} Songs", style: Theme.of(context).textTheme.bodyLarge),
              Spacer(),
              Container(
                height: kBottomNavigationBarHeight, alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("Shuffle", style: Theme.of(context).textTheme.labelMedium),
                        Iconify(
                          Ic.twotone_shuffle, size: 25,
                          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,),
                      ],
                    ),
                    Gap(5),
                    Container(height: 30, width: 1, color: Colors.white38),
                    Gap(5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Iconify(
                        Ic.twotone_play_arrow, size: 27,
                        color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
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
                  ],
                ),
              ),
              Gap(10)
            ],
          ),
        )
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
          return SongsTile(song);
        },
      ),
    );
  }
}