import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sonicity/firebase_options.dart';
import 'package:sonicity/src/audio/service_locator.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/views/navigation_view.dart';
import 'package:sonicity/utils/contants/themes.dart';
import 'package:sonicity/utils/widgets/report_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      mode: FeedbackMode.draw, themeMode: ThemeMode.system,
      feedbackBuilder: (BuildContext context, OnSubmit onSubmit, ScrollController? scrollController) {
        final textController = TextEditingController();
        return ReportSheet(
          textController: textController,
          scrollController: scrollController,
          onSubmit: onSubmit
        );
      },
      darkTheme: FeedbackThemeData.dark(),
      child: Obx(() => GetMaterialApp(
        title: 'Sonicity',
        debugShowCheckedModeBanner: false,
        home: NavigationView(),
        themeMode: settingsController.getThemeMode,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
      ),
    ));
  }
}