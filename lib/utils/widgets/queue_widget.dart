import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
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