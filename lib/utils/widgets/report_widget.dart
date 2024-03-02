// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:sonicity/src/firebase/database_methods.dart';
import 'package:sonicity/src/firebase/storage_methods.dart';
import 'package:sonicity/src/models/report.dart';
import 'package:sonicity/utils/contants/enums.dart';

class ReportSheet extends StatelessWidget {
  final TextEditingController textController;
  final ScrollController ? scrollController;
  final OnSubmit onSubmit;
  ReportSheet({super.key, required this.textController, required this.scrollController, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(16, scrollController != null ? 20 : 16, 16, 0),
                children: [
                  Text(
                    "Write your feedback here (Optional) -",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    key: Key('text_input_field'),
                    controller: textController,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: Colors.grey.shade300),
                    onChanged: (_) {},
                  ),
                ],
              ),
              if (scrollController != null)
                FeedbackSheetDragHandle(),
            ],
          ),
        ),
        TextButton(
          key: Key('submit_feedback_button'),
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          onPressed: () => onSubmit(textController.text),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class SpiderReport extends StatelessWidget {
  final Color color;
  SpiderReport({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Report",
      child: InkWell(
        onTap: () {
          BetterFeedback.of(context).show(
            (feedback) async {
              final storageMethods = Get.find<StorageMethods>();
              String downloadUrl = await storageMethods.uploadReportScreenshot(feedback.screenshot, Routes.navigation);
              final databaseMethods = Get.find<DatabaseMethods>();
              Report report = Report.fromJson(downlodUrl: downloadUrl, message: feedback.text);
              databaseMethods.uploadReport(report: report, views: Routes.navigation).then(
                (_) => Get.snackbar(
                  "", "", snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.grey.shade800,
                  titleText: Text(
                    "Success",
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                  messageText: Text(
                    "Thank you for sharing your feedback with us! We appreciate your input and will use it to enhance your app experience.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              );
            },
          );
        },
        child: Iconify(Mdi.spider, color: color, size: 27),
      ),
    );
  }
}