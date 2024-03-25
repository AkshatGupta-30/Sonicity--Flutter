import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';
import 'package:sonicity/utils/sections/sections.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
import 'package:super_string/super_string.dart';

class SongDetailsView extends StatelessWidget {
  SongDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder<SongDetailController>(
              init: SongDetailController(Get.arguments),
              builder: (controller) {
                return Obx(() {
                  Song song = controller.song.value;
                  if(song.isEmpty()) {
                    return Center(
                      child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                    );
                  }
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [_appBar(context, media, song, controller),];
                    },
                    body: _info(context, controller, song),
                  );
                });
              }
            ),
          ),
          MiniPlayerView()
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _floatingActionButton(),
    );
  }

  SliverAppBar _appBar(BuildContext context, Size media, Song song, SongDetailController controller) {
    return SliverAppBar(
      pinned: true, floating: false, snap: false,
      leading: BackButton(),
      expandedHeight: 360,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, expandedTitleScale: 1.5,
        stretchModes: [StretchMode.blurBackground],
        titlePadding: EdgeInsets.only(left: 10, right: 10, bottom: 60),
        title: SizedBox(
          width: media.width/1.4,
          child: Text(
            song.name, maxLines: 1, overflow: TextOverflow.ellipsis,  textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        background: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: song.image.highQuality, fit: BoxFit.fill,
              width: 400, height: 400,
              placeholder: (context, url) {
                return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.fill);
              },
              errorWidget: (context, url, error) {
                return Image.asset("assets/images/songCover/songCover500x500.jpg", fit: BoxFit.fill);
              },
            ),
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
      bottom: TabBar(
        controller: controller.tabController,
        isScrollable: false,
        physics: NeverScrollableScrollPhysics(),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Iconify(
                  IconParkTwotone.doc_detail, size: 25,
                  color: (controller.selectedTab.value == 0)
                    ? Get.find<SettingsController>().getAccent
                    : Get.find<SettingsController>().getAccentDark,
                )),
                Gap(8),
                Obx(() => Text(
                  "Details",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: (controller.selectedTab.value == 0)
                      ? Get.find<SettingsController>().getAccent
                      : Get.find<SettingsController>().getAccentDark
                  ),
                ))
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Iconify(
                  Ic.twotone_lyrics, size: 25,
                  color: (controller.selectedTab.value == 1)
                    ? Get.find<SettingsController>().getAccent
                    : Get.find<SettingsController>().getAccentDark,
                )),
                Gap(8),
                Obx(() => Text(
                  "Lyrics",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: (controller.selectedTab.value == 1)
                      ? Get.find<SettingsController>().getAccent
                      : Get.find<SettingsController>().getAccentDark
                  ),
                )),
              ],
            ),
          ),
        ]
      ),
    );
  }

  
  TabBarView _info(BuildContext context, SongDetailController controller, Song song) {
    return TabBarView(
      controller: controller.tabController,
      physics: NeverScrollableScrollPhysics(),
      children: <Container>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: ListView(
            children: [
              _divide(),
              _head(context, "Name"),
              _detail(context, song.name),
              _divide(),
              _head(context, "From Album"),
              _albumSection(song.album!),
              _divide(),
              _head(context, "Contributed Artists"),
              _artistSection(song.artists!),
              _divide(),
              _head(context, "Duration"),
              _detail(context, "${song.duration} seconds"),
              _divide(),
              _head(context, "Language"),
              _detail(context, song.language!.capitalizeFirst!),
              _divide(),
              _head(context, "Release Date"),
              _detail(context, song.releaseDate!),
              _divide(),
              _head(context, "Cover Image Url"),
              CoverImageSection(image: song.image),
              _divide(),
              _head(context, "Download Song"),
              DownloadUrlSection(downloadUrl: song.downloadUrl),
              _divide(),
            ],
          ),
        ),
        Container(
          child: (!controller.song.value.hasLyrics)
            ? Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Iconify(
                        Ic.twotone_error, size: 50,
                        color: (Theme.of(context).brightness == Brightness.light) ? Colors.red : Colors.redAccent,
                      ),
                      Text(
                        "This song doesn't have any available lyrics.", textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.redAccent),
                      )
                    ]
                  ),
                ),
              )
            )
            : ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 21),
              children: [
                Text(
                  controller.lyrics.value.snippet.title(), textAlign: TextAlign.center,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Gap(5),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          backgroundColor: Colors.grey.shade800,
                          title: "© Copyright",
                          titleStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.blue),
                          content: SelectableText(
                            controller.lyrics.value.copyright, textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                          )
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <InlineSpan>[
                            WidgetSpan(child: Iconify(Ic.twotone_copyright, color: Colors.blue, size: 27)),
                            TextSpan(
                              text: " Copyright",
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.blue)
                            )
                          ]
                        ),
                      )
                    ),
                  ],
                ),
                SelectableText.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: controller.lyrics.value.lyrics,
                    style: Theme.of(context).textTheme.bodyLarge
                  ),
                ),
              ],
            ),
        )
      ],
    );
  }

  Obx _floatingActionButton() {
    return Obx(() => ExpandableFab(
      duration: Duration(milliseconds: 250),
      distance: 100.0,
      type: ExpandableFabType.fan,
      pos: ExpandableFabPos.right,
      childrenOffset: Offset(0,0),
      fanAngle: 90,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: Iconify(IconParkTwotone.more_four, color: Get.find<SettingsController>().getAccent),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Get.find<SettingsController>().getAccent,
        backgroundColor: Get.find<SettingsController>().getAccentDark,
        shape: CircleBorder(),
        angle: 3.14 * 2,
      ),
      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 56,
        builder: (BuildContext context, void Function()? onPressed, Animation<double> progress) {
          return IconButton(
            onPressed: onPressed,
            icon: Iconify(AntDesign.close_circle_twotone, size: 40, color: Get.find<SettingsController>().getAccent),
          );
        },
      ),
      overlayStyle: ExpandableFabOverlayStyle(blur: 5),
      children: <Obx>[
        Obx(() => FloatingActionButton(
          onPressed: () {
            Get.to(() => ToDoView(text: "Add this song to playlist"));
          },
          tooltip: "Add to Playlist",
          backgroundColor: Get.find<SettingsController>().getAccentDark, shape: CircleBorder(),
          child: Iconify(Tabler.playlist_add, color: Get.find<SettingsController>().getAccent, size: 40)
        )),
        Obx(() => FloatingActionButton(
          onPressed: () {
            Get.to(() => ToDoView(text: "Play this song now"));
          },
          tooltip: "Play Now",
          backgroundColor: Get.find<SettingsController>().getAccentDark, shape: CircleBorder(),
          child: Iconify(Ic.twotone_play_arrow, color: Get.find<SettingsController>().getAccent, size: 40)
        )),
        Obx(() => FloatingActionButton(
          onPressed: () {
            Get.to(() => ToDoView(text: "Add this song to queue"));
          },
          tooltip: "Add to Queue",
          backgroundColor: Get.find<SettingsController>().getAccentDark, shape: CircleBorder(),
          child: Iconify(Ph.queue_bold, color: Get.find<SettingsController>().getAccent, size: 40)
        )),
      ],
    ));
  }

  Padding _divide() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Divider(),
    );
  }

  Text _head(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall);
  }

  Widget _detail(BuildContext context, String text, {bool isSelectable = false}) {
    if(isSelectable) {
      return SelectableText(text, style: Theme.of(context).textTheme.labelLarge);
    }
    return Text(text, style: Theme.of(context).textTheme.labelLarge);
  }

  AlbumCell _albumSection(Album album) {
    return AlbumCell(album, subtitle: "");
  }

  SizedBox _artistSection(List<Artist> artists) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          Artist artist = artists[index];
          return ArtistCell(artist, subtitle: "");
        }
      ),
    );
  }
}