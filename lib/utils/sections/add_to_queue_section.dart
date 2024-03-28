import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/widgets/queue_widget.dart';

class AddToQueueDialog extends StatelessWidget {
  final Song song;
  AddToQueueDialog(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: double.maxFinite, padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white, width: 0.5),
      ),
      child: GetBuilder(
        init: QueueController(song),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add To Queue', style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.normal),),
              Gap(10),
              Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.queues.length,
                itemBuilder: (context, index) {
                  Queue queue = controller.queues[index];
                  return QueueName(queue, controller, index: index,);
                },
              )),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => NewQueueDialog(controller),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(double.maxFinite, 0)),
                  alignment: Alignment.centerLeft
                ),
                child: Text('＋ New Queue', style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
              )
            ],
          );
        }
      ),
    );
  }
}