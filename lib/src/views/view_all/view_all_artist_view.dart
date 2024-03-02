// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/view_all_search_artist_controller.dart';
import 'package:sonicity/src/models/artist.dart';
import 'package:sonicity/utils/contants/enums.dart';
import 'package:sonicity/utils/widgets/artist_widget.dart';
import 'package:sonicity/utils/widgets/pop_up_buttons.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';
import 'package:super_string/super_string.dart';

class ViewAllArtistsView extends StatelessWidget {
  ViewAllArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: SpiderReport()),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: GetBuilder(
          init: ViewAllSearchArtistsController(Get.arguments),
          builder: (controller) {
            if(controller.artists.isEmpty) {
              return Center(
                child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
              );
            }
            return CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                _appBar(controller),
                _albumList(controller)
              ],
            );
          }
        ),
      ),
    );
  }

  SliverAppBar _appBar(ViewAllSearchArtistsController controller) {
    return SliverAppBar(
      pinned: true, floating: true, snap:  true,
      toolbarHeight: kToolbarHeight,
      shadowColor: Colors.black87, surfaceTintColor: Colors.grey.shade900, backgroundColor: Colors.grey.shade900,
      leading: BackButton(color: Colors.white),
      centerTitle: true,
      title: Text(
        "Artists - ${Get.arguments}".title(), maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return <PopupMenuItem>[
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
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Type Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.duration, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Type Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded, color: Colors.white),
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
              child: (controller.artists.length == 1)
              ? CachedNetworkImage(
                imageUrl: controller.artists.first.image!.highQuality, fit: BoxFit.cover,
                height: 320, width: 320,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/appLogo50x50.png",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
                placeholder: (context, url) {
                  return Image.asset(
                    "assets/images/appLogo50x50.png",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: 4, shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  String image = controller.artists[index].image!.standardQuality;
                  return CachedNetworkImage(
                    imageUrl: image, fit: BoxFit.cover,
                    height: 40, width: 40,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/images/appLogo50x50.png",
                        fit: BoxFit.cover, height: 40, width: 40,
                      );
                    },
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/appLogo50x50.png",
                        fit: BoxFit.cover, height: 40, width: 40,
                      );
                    },
                  );
                },
              ),
            ),
            Container(height: 360, width: double.maxFinite, color: Colors.black.withOpacity(0.45)),
            Container(
              margin: EdgeInsets.only(top: kToolbarHeight), alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Text>[
                  Text(
                    "Artists",
                    style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${controller.artistCount.value} Artists",
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 25),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverPadding _albumList(ViewAllSearchArtistsController controller) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      sliver: SliverList.builder(
        itemCount: (controller.isLoadingMore.value)
          ? controller.artists.length + 1
          : controller.artists.length,
        itemBuilder: (context, index) {
          if(index < controller.artists.length) {
            Artist artist = controller.artists[index];
            return ArtistTile(artist: artist, subtitle: artist.description!);
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    );
  }
}