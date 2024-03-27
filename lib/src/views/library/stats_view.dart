// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

final settings = Get.find<SettingsController>();

class StatsView extends StatelessWidget {
  StatsView({super.key});

  final settings = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Color(0xFF252525);
    return Scaffold(
      appBar: AppBar(title: Text('Stats'),),
      body: BackgroundGradientDecorator(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Wrap(
            spacing: 20, runSpacing: 20,
            children: [
              _songsPlayed(cardColor, textTheme),
              _todaySpentTime(cardColor, textTheme),
              _dailyAvgSpentTime(cardColor, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Card _songsPlayed(Color cardColor, TextTheme textTheme) {
    return Card(
      elevation: 3, color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox.square(
          child: Column(
            children: [
              Text('1024', style: textTheme.headlineLarge!.copyWith(color: settings.getAccent),),
              Text('Songs Played', style: textTheme.headlineSmall,),
            ],
          ),
        ),
      ),
    );
  }

  Card _todaySpentTime(Color cardColor, TextTheme textTheme) {
    return Card(
      elevation: 3, color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text('100 min', style: textTheme.titleLarge!.copyWith(color: settings.getAccent),),
            Text("Today's Duration", style: textTheme.titleSmall,),
          ],
        ),
      ),
    );
  }

  Card _dailyAvgSpentTime(Color cardColor, TextTheme textTheme) {
    return Card(
      elevation: 3, color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text('100 min', style: textTheme.titleLarge!.copyWith(color: settings.getAccent),),
            Text("Daily Average", style: textTheme.titleSmall,),
          ],
        ),
      ),
    );
  }
}
