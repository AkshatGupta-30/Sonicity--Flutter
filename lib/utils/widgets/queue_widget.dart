import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
import 'package:super_string/super_string.dart';

class NewQueueDialog extends StatelessWidget {
  final QueueController controller;
  const NewQueueDialog(this.controller, {super.key,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Get.find<SettingsController>();
    return GestureDetector(
      onTap: () => controller.searchQueueFocus.unfocus(),
      child: AlertDialog(
        elevation: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        backgroundColor: (theme.brightness == Brightness.light) ? Colors.white : Colors.black,
        shadowColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
        title: Text("New Queue"),
        titleTextStyle: theme.textTheme.labelLarge,
        content: TextField(
          controller: controller.newQueueTextController,
          cursorColor: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
          style: TextStyle(color: (theme.brightness == Brightness.light) ?Colors.black : Colors.white,),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccentDark, width: 2),),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccent, width: 3),),
            hintText: "Queue Name"
          ),
          onTap: () => controller.newQueueTfActive.value = true,
          focusNode: controller.newQueueFocus,
          onTapOutside: (event) {
            controller.newQueueFocus.unfocus();
            controller.newQueueTfActive.value = false;
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            icon: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text("Cancel", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              controller.createQueue();
            },
            padding: EdgeInsets.zero,
            icon: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: settings.getAccent,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text("Create", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
            ),
          )
        ]
      ),
    );
  }
}

class QueueName extends StatelessWidget {
  final Queue queue;
  final QueueController controller;
  final int index;
  QueueName(this.queue, this.controller, {super.key, required this.index,});

  final audioManager = getIt<AudioManager>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () async {
        controller.insertSong(queue.name);
        Navigator.pop(context);
      },
      style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Iconify(Ion.reorder_two),
          (queue.isCurrent) 
              ? Iconify(MaterialSymbols.arrow_right_rounded, color: Get.find<SettingsController>().getAccent, size: 27,)
              : Gap(27),
          Text(queue.name.title(), style: theme.primaryTextTheme.bodyLarge,),
          Spacer(),
          if(queue.name == controller.playingQueue.value.name) ...[
            ValueListenableBuilder(
              valueListenable: audioManager.playButtonNotifier,
              builder: (context, state, _) {
                return MiniMusicVisualizer(
                  color: Get.find<SettingsController>().getAccent,
                  animate: (state == ButtonState.playing),
                );
              }
            ),
            Gap(5),
          ],
          Text('${queue.songCount} Songs', style: theme.primaryTextTheme.bodySmall,),
        ],
      ),
    );
  }
}

class AllQueues extends StatelessWidget {
  final QueueDetailController controller;
  AllQueues(this.controller, {super.key,});

  final audioManager = getIt<AudioManager>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.maxFinite, padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white, width: 0.5),
      ),
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Iconify(Ic.round_queue_music),
              Gap(15),
              Text('Queues', style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.normal),),
            ],
          ),
          Gap(10),
          SizedBox(
            height: controller.queues.length * 72.0,
            child: ReorderableListView.builder(
              itemCount: controller.queues.length,
              onReorder: controller.onReorderQueues,
              itemBuilder: (context, index) {
                Queue queue = controller.queues[index];
                return ListTile(
                  key: Key(queue.name),
                  onTap: () {
                    controller.setSelectedQueue(queue);
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Iconify(Ion.reorder_two),
                      Iconify(
                        (queue == controller.selectedQueue.value) ? Ic.sharp_radio_button_checked : Ic.baseline_radio_button_unchecked,
                        color: (queue == controller.selectedQueue.value) ?  Get.find<SettingsController>().getAccent : Colors.grey,
                      ),
                    ],
                  ),
                  title: Text(queue.name.title()),
                  subtitle: Text('${queue.songCount} Songs'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(queue.name == controller.playingQueue.value.name) ...[
                        ValueListenableBuilder(
                          valueListenable: audioManager.playButtonNotifier,
                          builder: (context, state, _) {
                            return MiniMusicVisualizer(
                              color: Get.find<SettingsController>().getAccent,
                              animate: (state == ButtonState.playing),
                            );
                          }
                        ),
                        Gap(10),
                      ],
                      IconButton(
                        onPressed: () => showDialog(
                          context: context, barrierDismissible: true, useRootNavigator: true,
                          builder: (ctx) => RenameQueueDialog(controller, queue: queue),
                        ),
                        padding: EdgeInsets.zero,
                        icon: Iconify(Mdi.lead_pencil),
                      ),
                      Gap(2),
                      IconButton(
                        onPressed: () => showDialog(
                          context: context, barrierDismissible: true, useRootNavigator: true,
                          builder: (ctx) => RemoveQueueDialog(controller, queue: queue),
                        ),
                        padding: EdgeInsets.zero,
                        icon: Iconify(IconParkTwotone.delete_four)
                      ),
                      Gap(2)
                    ],
                  ),
                );
              },
            ),
          )
        ],
      )),
    );
  }
}

class RenameQueueDialog extends StatelessWidget {
  final Queue queue;
  final QueueDetailController controller;
  const RenameQueueDialog(this.controller, {super.key, required this.queue,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Get.find<SettingsController>();
    return AlertDialog(
      elevation: 10,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      backgroundColor: (theme.brightness == Brightness.light) ? Colors.white : Colors.black,
      shadowColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
      title: Text("Rename : ${queue.name}"),
      titleTextStyle: theme.textTheme.labelLarge,
      content: TextField(
        controller: controller.renameQueueTextController,
        cursorColor: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
        style: TextStyle(color: (theme.brightness == Brightness.light) ?Colors.black : Colors.white,),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccentDark, width: 2),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: settings.getAccent, width: 3),),
          hintText: "New Name"
        ),
        onTap: () => controller.renameQueueTfActive.value = true,
        focusNode: controller.renameQueueFocus,
        onTapOutside: (event) {
          controller.renameQueueFocus.unfocus();
          controller.renameQueueTfActive.value = false;
        },
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Text("Cancel", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            controller.renameQueue(queue);
          },
          padding: EdgeInsets.zero,
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: settings.getAccent,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Text("Done", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
          ),
        )
      ]
    );
  }
}

class RemoveQueueDialog extends StatelessWidget {
  final Queue queue;
  final QueueDetailController controller;
  const RemoveQueueDialog(this.controller, {super.key, required this.queue,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Get.find<SettingsController>();
    return AlertDialog(
      elevation: 10,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      backgroundColor: (theme.brightness == Brightness.light) ? Colors.white : Colors.black,
      shadowColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
      title: Text("Confirm Delete"),
      titleTextStyle: theme.textTheme.labelLarge,
      content: Text('Are you sure you want to delete `${queue.name}`'),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Text("Cancel", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            controller.deleteQueue(queue);
          },
          padding: EdgeInsets.zero,
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: settings.getAccent,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Text("Confirm", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
          ),
        )
      ]
    );
  }
}