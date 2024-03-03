// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/utils/contants/colors.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final controller = Get.find<SettingsController>();

  final keyThemeMode = 'theme-mode';
  final keyAccent = 'accent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => ListView(
          children: [
            SettingsGroup(
              title: "Theme",
              titleTextStyle: TextStyle(color: controller.getAccent, fontWeight: FontWeight.bold, fontSize: 21),
              children: [
                _buildTheme(),
                _buildAccent(),
              ],
            )
          ],
        ),
      )),
    );
  }

  DropDownSettingsTile<int> _buildTheme() {
    return DropDownSettingsTile(
      settingKey: keyThemeMode,
      leading: Iconify(Mdi.theme_light_dark),
      title: "Theme Mode",
      selected: 1,
      values: {1 : "System", 2 : "Light Mode", 3 : "Dark Mode"},
      onChange: (value) {
        if(value == 1) {controller.setThemeMode = ThemeMode.system;}
        else if(value == 2) {controller.setThemeMode = ThemeMode.light;}
        else {controller.setThemeMode = ThemeMode.dark;}
      },
    );
  }

  _buildAccent() {
    return Obx(() {
      Color accent = controller.getAccent;
      return ListTile(
        leading: Iconify(Ion.color_palette, color: accent),
        title: Text("Accent Color"),
        subtitle: Text("Red - ${accent.red} | Green - ${accent.green} | Blue - ${accent.blue}"),
        trailing: CircleAvatar(radius: 16, backgroundColor: accent),
        onTap: () => Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SizedBox(
              height: 650,
              child: Scaffold(
                appBar: AppBar(title: Text("Pick Color")),
                body: Obx(() => ListView(
                  children: [
                    Wrap(
                      children: List.generate(lightColorList.length, (index) => GestureDetector(
                        onTap: () async {
                          controller.setAccentIndex = index;
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('accent-index', index);
                        },
                        child: Container(
                          margin: EdgeInsets.all(9),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: lightColorList[index].withOpacity((controller.getAccentIndex == index) ? 0.9 : 1),
                            child: (controller.getAccentIndex == index)
                              ? Iconify(MaterialSymbols.done_rounded, size: 40, color: Colors.white)
                              : null,
                          ),
                        ),
                      )),
                    )
                  ],
                )),
              ),
            ),
          )
        ),
      );
    });
  }
}