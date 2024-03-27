import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class QueueView extends StatelessWidget {
  QueueView({super.key});
  
  final controller = Get.find<QueueController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientDecorator(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(// * : Queue Dialog
                  children: [
                    Expanded(// TODO - Queue Dialog
                      child: IconButton(
                        onPressed: () => controller.showAllQueueDialog(context),
                        padding: EdgeInsets.zero,
                        icon: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Row(
                            children: [
                              Text('Queue 1'),
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
                Container(// * : Songs Summary
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Row(
                    children: [
                      Iconify(Ic.baseline_play_arrow, size: 30,),// TODO - Play Songs
                      Spacer(),
                      Column(
                        children: [// * : Songs Details
                          Text('29 / 591'),// TODO - Current Song index / Total songs length
                          Gap(2),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.timer, size: 16,)),
                                WidgetSpan(child: Gap(5)),
                                TextSpan(text: '38:54:05')// TODO - Total duration of queue
                              ]
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Iconify(MaterialSymbols.sort_rounded, size: 30,),// TODO - Sort Queue
                    ],
                  ),
                ),
                Gap(4),
                Divider(height: 2, thickness: 2,),
                Expanded(// * : Songs
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) => controller.onNotification(notification),
                    child: ReorderableListView.builder(
                      itemCount: 40,
                      onReorder: (oldIndex, newIndex) {},
                      itemBuilder: (context, index) {
                        return Container(
                          key: Key(index.toString()),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: (index == 4) ? Get.find<SettingsController>().getAccent : Colors.transparent),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: ListTile(
                            onTap: () {}, // TODO - Play from this song
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Iconify(Ion.reorder_two),// TODO - Reorder Song in queue
                                Gap(10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(// TODO - song.image
                                    'assets/images/songCover/songCover500x500.jpg',
                                    width: 50, height: 50, fit: BoxFit.cover,)
                                  )
                              ],
                            ),
                            title: Text('Song Title - $index'),// TODO - Song title
                            subtitle: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(child: Text('Song Subtitle - $index')),// TODO - Song subtitle
                                Text('$index:$index'),// TODO - Song duration
                              ],
                            ),
                            trailing: Iconify(MaterialSymbols.more_vert, size: 32,),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
            onPressed: () {},// TODO - Shuffle and play songs
            shape: CircleBorder(), backgroundColor: Theme.of(context).cardColor,
            child: Iconify(Wpf.shuffle, color: Get.find<SettingsController>().getAccent,),
          ),
        ),
      ),
    ));
  }
}