import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/controllers/queue_detail_controller.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class QueueView extends StatelessWidget {
  QueueView({super.key});

  @override
  Widget build(BuildContext context) {
    final audioManager = getIt<AudioManager>();
    return GetBuilder(
      init: QueueDetailController(),
      builder: (controller) {
        return Scaffold(
          body: BackgroundGradientDecorator(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(// * : Queue Dialog
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                alignment: Alignment.center,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: AllQueues(controller),
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            icon: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Row(
                                children: [
                                  Obx(() => Text(controller.selectedQueue.value.name)),
                                  Spacer(),
                                  Iconify(MaterialSymbols.arrow_drop_down_rounded)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Gap(20),
                        Iconify(MaterialSymbols.close_rounded),// TODO - Remove Queue
                        Gap(5)
                      ],
                    ),
                    if(controller.selectedQueue.value.songs == null)
                      CircularProgressIndicator()
                    else  ...[
                      Container(// * : Songs Summary
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => playSongs(controller.selectedQueue.value.songs!, index: 0),
                              icon: Iconify(Ic.baseline_play_arrow, size: 30,)
                            ),
                            Spacer(),
                            Column(
                              children: [// * : Songs Details
                                Obx(() {
                                  if(controller.selectedQueue.value.songs == null || controller.selectedQueue.value.songs!.isEmpty) {
                                    return Text('0 / 0');
                                  }
                                  return Text('${controller.currentSongIndex.value + 1} / ${controller.selectedQueue.value.songs!.length}');
                                }),
                                Gap(2),
                                Row(
                                  children: [
                                    Icon(Icons.timer, size: 16,),
                                    Gap(5),
                                    Obx(() {
                                      if(controller.selectedQueue.value.songs == null || controller.selectedQueue.value.songs!.isEmpty) {
                                        return Text('00:00');
                                      }
                                      return Text(controller.formatDuration(controller.selectedQueue.value.songs!));
                                    })
                                  ]
                                ),
                              ],
                            ),
                            Spacer(),
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
                              icon: Iconify(MaterialSymbols.sort_rounded, color: Theme.of(context).appBarTheme.actionsIconTheme!.color, size: 30,),
                              padding: EdgeInsets.zero,
                              position: PopupMenuPosition.under, color: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            )
                          ],
                        ),
                      ),
                      Gap(4),
                      Divider(height: 2, thickness: 2,),
                      Expanded(// * : Songs
                        child: NotificationListener<UserScrollNotification>(
                          onNotification: (notification) => controller.onNotification(notification),
                          child: ValueListenableBuilder(
                            valueListenable: audioManager.currentSongNotifier,
                            builder: (context, currentSong, _) {
                              return Obx(() => ListView.builder(// TODO - Reorder
                                itemCount: controller.selectedQueue.value.songs!.length,
                                itemBuilder: (context, index) {
                                  Song song = controller.selectedQueue.value.songs![index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: (currentSong != null && song.id == currentSong.id)
                                            ? Get.find<SettingsController>().getAccent
                                            : Colors.transparent
                                      ),
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: ListTile(
                                      onTap: () => playSongs(controller.selectedQueue.value.songs!, index: index),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      leading: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Iconify(Ion.reorder_two),// TODO - Reorder Song in queue
                                          // Gap(10),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: song.image.highQuality, width: 50, height: 50, fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Image.asset(
                                                'assets/images/songCover/songCover500x500.jpg',
                                                width: 50, height: 50, fit: BoxFit.cover,
                                              ),
                                              placeholder: (context, url) => Image.asset(
                                                'assets/images/songCover/songCover500x500.jpg',
                                                width: 50, height: 50, fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(song.title),
                                      subtitle: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(child: Text(song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                          Gap(10),
                                          Text(controller.formatDuration([song])),
                                        ],
                                      ),
                                      trailing: Iconify(MaterialSymbols.more_vert, size: 32,),
                                    ),
                                  );
                                },
                              ));
                            }
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Obx(() => AnimatedSlide(
            offset: (controller.showFab.value) ? Offset.zero : Offset(0, 2),
            duration: Duration(milliseconds: 300),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: (controller.showFab.value) ? 1 : 0,
              child: FloatingActionButton(
                onPressed: () => playSongs(controller.selectedQueue.value.songs!, index: 0, shuffle: true),
                shape: CircleBorder(), backgroundColor: Theme.of(context).cardColor,
                child: Iconify(Wpf.shuffle, color: Get.find<SettingsController>().getAccent,),
              ),
            ),
          ),
        ));
      }
    );
  }
}