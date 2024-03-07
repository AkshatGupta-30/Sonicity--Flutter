import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/controllers/view_all_search_song_controller.dart';
import 'package:sonicity/src/models/song.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:sonicity/utils/widgets/song_widget.dart';
import 'package:super_string/super_string.dart';

class ViewAllSongsView extends StatelessWidget {
  ViewAllSongsView({super.key});
  final controller = Get.find<ViewAllSearchSongsController>();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: (Theme.of(context).brightness == Brightness.light)
              ? [Colors.grey.shade200, Colors.white]
              : [Colors.grey.shade800, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Obx(() {
          if(controller.songs.isEmpty) {
            return Center(
              child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
            );
          }
          return CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              _appBar(context, media, controller),
              _songList(controller)
            ],
          );
        }),
      ),
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
    );
  }

  SliverAppBar _appBar(BuildContext context, Size media, ViewAllSearchSongsController controller) {
    return SliverAppBar(
      pinned: true, floating: true, snap:  true,
      toolbarHeight: kToolbarHeight,
      leading: BackButton(),
      title: Text("Songs - ${Get.arguments}".title(), maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
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
          icon: Iconify(MaterialSymbols.sort_rounded, color: Theme.of(context).appBarTheme.actionsIconTheme!.color),
          position: PopupMenuPosition.under, color: Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        Gap(8)
      ],
      expandedHeight: 200 + kToolbarHeight,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.blurBackground],
        background: Container(
          height: 200,
          padding: EdgeInsets.only(top: kToolbarHeight), alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 160, width: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (controller.songs.length < 4)
                    ? CachedNetworkImage(
                    imageUrl: controller.songs.first.image.medQuality,
                    fit: BoxFit.cover, height: 160, width: 160,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/images/appLogo/appLogo50x50.png",
                        fit: BoxFit.cover, height: 160, width: 160,
                      );
                    },
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/appLogo/appLogo50x50.png",
                        fit: BoxFit.cover, height: 160, width: 160,
                      );
                    },
                  )
                    : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: 4, shrinkWrap: true,
                      padding: EdgeInsets.zero, physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String image = controller.songs[index].image.medQuality;
                        return CachedNetworkImage(
                          imageUrl: image, fit: BoxFit.cover,
                          height: 40, width: 40,
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              "assets/images/appLogo/appLogo50x50.png",
                              fit: BoxFit.cover, height: 40, width: 40,
                            );
                          },
                          placeholder: (context, url) {
                            return Image.asset(
                              "assets/images/appLogo/appLogo50x50.png",
                              fit: BoxFit.cover, height: 40, width: 40,
                            );
                          },
                        );
                      },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Songs", style: Theme.of(context).textTheme.headlineLarge),
                  Text("${controller.songCount.value} Songs", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey)),
                  Gap(12),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(// * : Play Button
                        onTap: (){},
                        borderRadius: BorderRadius.circular(15),
                        child: Obx(
                          () {
                            final settings = Get.find<SettingsController>();
                            return Container(
                              padding: EdgeInsets.only(left: 5, top: 10, right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: LinearGradient(
                                  colors: [
                                    settings.getAccent,
                                    (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white
                                  ],
                                  begin: Alignment.center, end: Alignment.bottomCenter,
                                  stops: [0.25, 1], tileMode: TileMode.clamp
                                )
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Iconify(Ic.twotone_play_arrow, size: 30),
                                  Gap(3),
                                  Text(
                                    "Play",
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white
                                    )
                                  )
                                ],
                              )
                            );
                          }
                        ),
                      ),
                      Gap(10),
                      InkWell(
                        onTap: (){},
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: (Theme.of(context).brightness == Brightness.light) ?Colors.black : Colors.white,
                              width: 2
                            ),
                          ),
                          child: Iconify(Ph.shuffle_duotone, size: 30)
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SliverPadding _songList(ViewAllSearchSongsController controller) {
    return SliverPadding(
      padding: EdgeInsets.all(15),
      sliver: SliverList.builder(
        itemCount: (controller.isLoadingMore.value)
          ? controller.songs.length + 1
          : controller.songs.length,
        itemBuilder: (context, index) {
          if(index < controller.songs.length) {
            Song song = controller.songs[index];
            return SongsTile(song);
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    );
  }
}