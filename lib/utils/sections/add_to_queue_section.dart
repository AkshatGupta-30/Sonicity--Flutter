import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';

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
        border: Border.all(color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white, width: 2),
      ),
      child: GetBuilder(
        init: QueueController(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add To Queue', style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.normal),),
              Gap(10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 50,
                itemBuilder: (context, index) {
                  return SizedBox();
                },
              ),
              TextButton(
                onPressed: () {},
                child: Text('＋ New Queue', style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
              )
            ],
          );
        }
      ),
    );
  }
}