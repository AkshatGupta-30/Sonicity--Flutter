import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
import 'package:super_string/super_string.dart';

class ViewAllAlbumsView extends StatelessWidget {
  ViewAllAlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: ViewAllSearchAlbumsController(Get.arguments),
              builder: (controller) {
                if(controller.albums.isEmpty) {
                  return Center(
                    child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                  );
                }
                return CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    _appBar(context, controller),
                    _albumList(controller)
                  ],
                );
              }
            ),
          ),
          MiniPlayerView()
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context, ViewAllSearchAlbumsController controller) {
    return SliverAppBar(
      pinned: true, floating: true, snap:  true,
      leading: BackButton(),
      title: Text("Albums - ${Get.arguments}".title(), maxLines: 1, overflow: TextOverflow.ellipsis),
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
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Song Count Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.duration, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Song Count Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded, color: Theme.of(context).appBarTheme.actionsIconTheme!.color),
          position: PopupMenuPosition.under, color: Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        Gap(8)
      ],
      expandedHeight: 320,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Container>[
            Container(
              height: 360, width: double.maxFinite, decoration: BoxDecoration(),
              child: (controller.albums.length == 1)
              ? CachedNetworkImage(
                imageUrl: controller.albums.first.image!.highQuality, fit: BoxFit.cover,
                height: 320, width: 320,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/albumCover/albumCover500x500.jpg",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/albumCover/albumCover500x500.jpg",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: 4, shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  String image = controller.albums[index].image!.medQuality;
                  return CachedNetworkImage(
                    imageUrl: image, fit: BoxFit.cover,
                    height: 40, width: 40,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/images/albumCover/albumCover50x50.jpg",
                        fit: BoxFit.cover, height: 40, width: 40,
                      );
                    },
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/albumCover/albumCover50x50.jpg",
                        fit: BoxFit.cover, height: 40, width: 40,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              height: 360, width: double.maxFinite,
              color: (Theme.of(context).brightness == Brightness.light) ? Colors.white.withOpacity(0.45) : Colors.black.withOpacity(0.45)
            ),
            Container(
              margin: EdgeInsets.only(top: kToolbarHeight), alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Text>[
                  Text(
                    "Albums",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white
                    )
                  ),
                  Text(
                    "${controller.albumCount.value} Albums",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverPadding _albumList(ViewAllSearchAlbumsController controller) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      sliver: SliverList.builder(
        itemCount: (controller.isLoadingMore.value)
          ? controller.albums.length + 1
          : controller.albums.length,
        itemBuilder: (context, index) {
          if(index < controller.albums.length) {
            Album album = controller.albums[index];
            return AlbumTile(album, subtitle: "${album.songCount} Songs");
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    );
  }
}