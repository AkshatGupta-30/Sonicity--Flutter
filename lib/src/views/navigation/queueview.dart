import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/library/library_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class QueueView extends StatelessWidget {
  QueueView({super.key});

  final controller = Get.find<NavigationController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioManager = getIt<AudioManager>();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => controller.tabController.animateTo(1),
      child: GetBuilder(
        init: QueueDetailController(),
        builder: (controller) {
          return Scaffold(
            body: BackgroundGradientDecorator(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _allQueuesHeader(context, controller),
                      if(controller.queues.isEmpty)
                        Expanded(child: Center(child: Text('No Tracks Queued Up', style: theme.textTheme.titleLarge!.copyWith(
                          color: (theme.brightness == Brightness.light) ? Colors.yellow.shade900 : Colors.yellow.shade100,
                        ))))
                      else if(controller.selectedQueue.value.songs == null)
                        Expanded(child: Center(child: CircularProgressIndicator(color: settings.getAccent,)))
                      else  ...[
                        _songsSummary(controller, audioManager, context),
                        Gap(4),
                        Divider(height: 2, thickness: 2,),
                        _allSongs(controller, audioManager),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: _shuffleButton(controller, audioManager));
        }
      ),
    );
  }

  Widget _allQueuesHeader(BuildContext context, QueueDetailController controller) {
    if(controller.queues.isEmpty) return SizedBox();
    return Row(// * : Queue Dialog
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
        Gap(5),
        IconButton(
          onPressed: () => showDialog(
            context: context, barrierDismissible: true, useRootNavigator: true,
            builder: (ctx) => RemoveQueueDialog(controller, queue: controller.selectedQueue.value),
          ),
          padding: EdgeInsets.zero,
          icon: Iconify(MaterialSymbols.close_rounded)
        ),
        Gap(5)
      ],
    );
  }

  Container _songsSummary(QueueDetailController controller, AudioManager audioManager, BuildContext context) {
    return Container(// * : Songs Summary
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              playSongs(controller.selectedQueue.value.songs!, index: 0);
              controller.playlingQueue.value = controller.selectedQueue.value;
            },
            icon: Iconify(Ic.baseline_play_arrow, size: 30,)
          ),
          Spacer(),
          Column(
            children: [// * : Songs Details
              Obx(() {
                if(controller.selectedQueue.value.songs == null || controller.selectedQueue.value.songs!.isEmpty) {
                  return Text('0 / 0');
                }
                return ValueListenableBuilder(
                  valueListenable: audioManager.currentSongNotifier,
                  builder: (context, currentSong, _) {
                    controller.setCurrentIndex(currentSong);
                    return Obx(() => Text('${controller.currentSongIndex.value} / ${controller.selectedQueue.value.songs!.length}'));
                  }
                );
              }),
              Gap(2),
              Row(
                children: [
                  Icon(Icons.timer, size: 16,),
                  Gap(5),
                  Obx(() {
                    if(controller.selectedQueue.value.songs == null || controller.selectedQueue.value.songs!.isEmpty) {
                      return Text('00:00:00');
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
    );
  }

  Expanded _allSongs(QueueDetailController controller, AudioManager audioManager) {
    return Expanded(// * : Songs
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) => controller.onNotification(notification),
        child: ValueListenableBuilder(
          valueListenable: audioManager.currentSongNotifier,
          builder: (context, currentSong, _) {
            return ValueListenableBuilder(
              valueListenable: audioManager.playlistNotifier,
              builder: (context, currentQueue, _) {
                final queueStateIndex = (audioManager.currentSongNotifier.value == null)
                    ? 0 : currentQueue.indexOf(audioManager.currentSongNotifier.value!);
                return Obx(() => ReorderableListView.builder(
                  padding: EdgeInsets.only(bottom: 90),
                  itemCount: (controller.selectedQueue.value.songs == null) ? 0 : controller.selectedQueue.value.songs!.length,
                  onReorder: controller.onReorderSongs,
                  itemBuilder: (context, index) {
                    Song song = controller.selectedQueue.value.songs![index];
                    return Dismissible(
                      key: Key(song.id),
                      direction: (index == queueStateIndex) ? DismissDirection.none : DismissDirection.horizontal,
                      onDismissed: (direction) {
                        audioManager.removeQueueItemAt(index);
                        controller.playlingQueue.value.songs!.removeAt(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: (
                              currentSong != null && 
                              song.id == currentSong.id && 
                              controller.selectedQueue.value.name == controller.playlingQueue.value.name
                            ) ? Get.find<SettingsController>().getAccent : Colors.transparent
                          ),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: ListTile(
                          onTap: () => playSongs(controller.selectedQueue.value.songs!, index: index),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Iconify(Ion.reorder_two),
                              Gap(10),
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
                          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(child: Text(song.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              Gap(10),
                              Text(controller.formatDuration([song], short: true)),
                            ],
                          ),
                          trailing: Iconify(MaterialSymbols.more_vert, size: 32,),
                        ),
                      ),
                    );
                  },
                ));
              }
            );
          }
        ),
      ),
    );
  }

  Obx _shuffleButton(QueueDetailController controller, AudioManager audioManager) {
    return Obx(() => (controller.queues.isNotEmpty)
        ? AnimatedSlide(
          offset: (controller.showFab.value) ? Offset.zero : Offset(0, 2),
          duration: Duration(milliseconds: 300),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: (controller.showFab.value) ? 1 : 0,
            child: ValueListenableBuilder(
              valueListenable: audioManager.currentSongNotifier,
              builder: (context, currentSong, _) {
                return Padding(
                  padding: EdgeInsets.only(bottom: (currentSong == null) ? 0 : 80),
                  child: FloatingActionButton(
                    onPressed: () {
                      playSongs(controller.selectedQueue.value.songs!, index: 0, shuffle: true);
                      controller.playlingQueue.value = controller.selectedQueue.value;
                    },
                    shape: CircleBorder(), backgroundColor: Theme.of(context).cardColor,
                    child: Iconify(Wpf.shuffle, color: Get.find<SettingsController>().getAccent,),
                  ),
                );
              }
            ),
          ),
        )
        : SizedBox()
    );
  }
}

// TODO - When a queue is playing and another song is added to queue then add that new song in audio manager queue