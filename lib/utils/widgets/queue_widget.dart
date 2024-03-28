import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/controllers/queue_detail_controller.dart';
import 'package:sonicity/src/models/models.dart';
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text("Cancel", style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              controller.createQueue();
            },
            child: Container(
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        controller.insertSong(queue.name);
        Navigator.pop(context);
      },
      style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          (queue.isCurrent) 
              ? Iconify(MaterialSymbols.arrow_right_rounded, color: Get.find<SettingsController>().getAccent, size: 27,)
              : Gap(27),
          Text(queue.name.title(), style: theme.primaryTextTheme.bodyLarge,),
          Spacer(),
          Text('${queue.songCount} Songs', style: theme.primaryTextTheme.bodySmall,),
        ],
      ),
    );
  }
}

class AllQueues extends StatelessWidget {
  final QueueDetailController controller;
  AllQueues(this.controller, {super.key,});

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
      child: Column(
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
            child: Obx(() => ReorderableListView.builder(
              itemCount: controller.queues.length,
              onReorder: (oldIndex, newIndex) {
                Queue temp = controller.queues[oldIndex];
                controller.queues[oldIndex] = controller.queues[newIndex];
                controller.queues[newIndex] = temp;
              },
              itemBuilder: (context, index) {
                Queue queue = controller.queues[index];
                return ListTile(
                  key: Key(queue.name),
                  onTap: () {
                    controller.setSelectedQueue(queue);
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Iconify(
                    (queue == controller.selectedQueue.value) ? Ic.sharp_radio_button_checked : Ic.baseline_radio_button_unchecked,
                    color: (queue == controller.selectedQueue.value) ?  Get.find<SettingsController>().getAccent : Colors.grey,
                  ),
                  title: Text(queue.name.title()),
                  subtitle: Text('${queue.songCount} Songs'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Iconify(Mdi.lead_pencil),// TODO - Rename Queue
                      Gap(10),
                      Iconify(IconParkTwotone.delete_four),// TODO - Delete Queue
                      Gap(8)
                    ],
                  ),
                );
              },
            )),
          )
        ],
      ),
    );
  }
}