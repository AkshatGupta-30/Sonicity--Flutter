import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class QueueController extends GetxController {
  final showFab = true.obs;

  bool onNotification(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    if (direction == ScrollDirection.reverse) showFab.value = false;
    else if (direction == ScrollDirection.forward) showFab.value = true;
    return true;
  }

  void showAllQueueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}