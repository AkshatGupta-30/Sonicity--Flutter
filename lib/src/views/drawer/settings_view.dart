// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:iconify_flutter_plus/icons/entypo.dart';
import 'package:iconify_flutter_plus/icons/eos_icons.dart';
import 'package:iconify_flutter_plus/icons/fe.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/radix_icons.dart';
import 'package:iconify_flutter_plus/icons/simple_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/src/views/todo/todo_view.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/contants/fonts.dart';
import 'package:sonicity/utils/contants/prefs_keys.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/iconify.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';
import 'package:super_string/super_string.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientDecorator(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              TitleSection(title: "Theme"),
              Gap(5),
              _buildTheme(context),
              Gap(10),
              _buildAccent(context),
              Gap(10),
              _buildFont(context),
              Gap(10),
              _buildBackground(context),
              Gap(20),
              TitleSection(title: "App Ui"),
              Gap(5),
              _buildPlayerBackground(context),
              Gap(10),
              _buildDenseMiniPlayer(context),
              Gap(20),
              TitleSection(title: "Music & Playback"),
              Gap(5),
              _buildMusicLanguage(context),
              Gap(10),
              _buildMusicQualitySettings(context),
              Gap(10),
              _buildRecentsSongLimit(context),
            ],
          ),
        ),
      ),
    );
  }

  Obx _buildTheme(BuildContext context) {
    return Obx(() {
      ThemeData theme = Theme.of(context);
      return ListTile(
        leading: Iconify(
          (controller.getThemeMode == ThemeMode.system)
            ? Mdi.theme_light_dark
            : (controller.getThemeMode == ThemeMode.light)
              ? Ic.twotone_wb_sunny
              : Ph.moon_stars_duotone,
        ),
        title: Text(
          "Theme Mode",
          style: theme.textTheme.labelMedium!.copyWith(
            color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
          ),
        ),
        trailing: DropdownButton(
          value: (controller.getThemeMode == ThemeMode.system) ? "System" : (controller.getThemeMode == ThemeMode.light) ? "Light Mode" : "Dark Mode",
          items: ["System" , "Light Mode", "Dark Mode"].map(
            (item) => DropdownMenuItem(value: item, child: Text(item))
          ).toList(),
          onChanged: (newValue) async {
            if(newValue == "System") {controller.setThemeMode = ThemeMode.system;}
            else if(newValue == "Light Mode") {controller.setThemeMode = ThemeMode.light;}
            else {controller.setThemeMode = ThemeMode.dark;}

            String theme = (controller.getThemeMode == ThemeMode.system)
              ? "System" : (controller.getThemeMode == ThemeMode.light) ? "Light Mode" : "Dark Mode";
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(PrefsKey.themeMode, theme);
          },
          icon: Iconify(Ic.twotone_arrow_drop_down_circle,),
          padding: EdgeInsets.zero,
          underline: SizedBox(),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          style: theme.textTheme.labelMedium!.copyWith(
            color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white
          ),
        ),
      );
    });
  }

  Obx _buildAccent(BuildContext context) {
    return Obx(() {
      ThemeData theme = Theme.of(context);
      Color accent = controller.getAccent;
      return ListTile(
        leading: Iconify(Ion.color_palette, color: accent),
        title: Text("Accent Color"),
        subtitle: Text("Red - ${accent.red} | Green - ${accent.green} | Blue - ${accent.blue}"),
        trailing: CircleAvatar(radius: 16, backgroundColor: accent),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SizedBox(
              height: 650,
              child: Scaffold(
                backgroundColor: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
                appBar: AppBar(title: Text("Pick Color")),
                body: Obx(() => ListView(
                  children: [
                    Wrap(
                      children: List.generate(lightColorList.length, (index) => GestureDetector(
                        onTap: () async {
                          controller.setAccentIndex = index;
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt(PrefsKey.accentIndex, index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(9),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: lightColorList[index].withOpacity((controller.getAccentIndex == index) ? 0.9 : 1),
                            child: (controller.getAccentIndex == index)
                              ? Iconify(MaterialSymbols.done_rounded, size: 40,)
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

  ListTile _buildFont(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Iconify(RadixIcons.font_family,),
      title: Text("Font Family"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(controller.fontFamily.value),
          Iconify(MaterialSymbols.arrow_right_rounded,)
        ]
      ),
      onTap: () => showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            height: 650,
            child: Scaffold(
              backgroundColor: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
              appBar: AppBar(title: Text("Choose Font")),
              body: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: Fonts.fontList.length,
                itemBuilder: (context, index) {
                  String font  = Fonts.fontList[index];
                  return Obx(() => TextButton(
                    onPressed: () async {
                      if(controller.fontFamily.value != font) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(PrefsKey.fontFamily, font);
                        controller.setFontfamily = font;
                        Get.showSnackbar(
                          GetSnackBar(
                            title: "Info", message: "New setting will be applied on app restart",
                            duration: Duration(seconds: 2),
                          )
                        );
                      }
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                    child: (controller.fontFamily.value == font)
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Iconify(Ion.checkmark_done_circle_sharp, color: Colors.green, size: 30,),
                          Gap(10),
                          Text(
                            font,
                            style: TextStyle(
                              color: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
                              fontFamily: font, fontSize: 25
                            )
                          )
                        ],
                      )
                      : Text(
                        font,
                        style: TextStyle(
                          color: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
                          fontFamily: font, fontSize: 25
                        )
                      ),
                  ));
                },
              ),
            )
          )
        ),
      ),
    );
  }

  _buildBackground(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Iconify(Ph.selection_background_duotone, color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,),
      title: Text("Background"),
      trailing: Iconify(Ic.round_arrow_right,),
      onTap: () => ToDoView(text: "Background")
    );
  }

  _buildPlayerBackground(BuildContext context) {
    return ListTile(
      leading: Iconify(Carbon.gradient,),
      title: Text("Main Player Background"),
      trailing: Container(
        height: 32, width: 32,
        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle,),
      ),
      onTap: () => ToDoView(text: "Background")
    );
  }

  _buildDenseMiniPlayer(BuildContext context) {
    return ListTile(
      leading: Iconify(Fe.tiled,),
      title: Text("Use dense mini player"),
      trailing: Obx(() => Switch(
        value: controller.getDensePlayer,
        onChanged: (newValue) async {
          controller.setDensePlayer = newValue;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(PrefsKey.useDensePlayer, newValue);
        },
        activeTrackColor: controller.getAccentDark,
        activeColor: controller.getAccent,
        inactiveTrackColor: Colors.grey,
        inactiveThumbColor: Colors.grey.shade300,
      ),
    ));
  }

  ListTile _buildMusicLanguage(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Iconify(Entypo.language,),
      title: Text("Music Language"),
      subtitle: Text("To display songs on home screen"),
      trailing: Text(controller.getMusicLang.replaceAll(",", ", ").title(), maxLines: 1, overflow: TextOverflow.ellipsis,),
      onTap: () =>  Get.bottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        Container(
          height: 600, width: double.maxFinite,
          color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          child: Column(
            children: [
              AppBar(title: Text("Select atleast one language"),),
              SizedBox(
                height: 475 - kToolbarHeight, width: double.maxFinite,
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4),
                  itemCount: int.parse((controller.availableLang.length / 1).floor().toString()),
                  itemBuilder: (context, index) {
                    String lang = controller.availableLang[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      title: Text(lang.title(), style: Theme.of(context).textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      trailing: Obx(() => Checkbox(
                        value: controller.musicLang.value.contains(lang),
                        onChanged: (value) async {
                          if(value!) {
                            if (!controller.musicLang.value.contains(lang)) {
                              (controller.musicLang.value.isEmpty)
                                ? controller.musicLang.value += lang
                                : controller.musicLang.value += ",$lang";
                            }
                          } else {
                            if (controller.musicLang.value.contains(lang)) {
                              controller.musicLang.value = controller.musicLang.value.replaceAll("$lang,", "");
                              controller.musicLang.value = controller.musicLang.value.replaceAll(lang, "");
                            }
                          }
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(PrefsKey.musicLanguage, controller.musicLang.value);
                        },
                        activeColor: controller.getAccent,
                      )),
                    );
                  },
                ),
              ),
            ]
          ),
        )
      ),
    );
  }

  final qualities = ["12kbps" , "48kbps", "96kbps", "160kbps", "320kbps"];
  _buildMusicQualitySettings(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Iconify(SimpleIcons.audiomack,),
      title: Text("Music Quality"),
      subtitle: Text("Customize Your Music Quality"),
      trailing: Obx(() => DropdownButton(
          value: controller.getMusicQuality,
          items: qualities.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: (newValue) async {
            controller.setMusicQuality = qualities[qualities.indexOf(newValue!)];
            controller.setMusicQuality = newValue;
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(PrefsKey.musicQuality, controller.getMusicQuality);
          },
          icon: Iconify(MaterialSymbols.arrow_drop_down_rounded,),
          padding: EdgeInsets.zero,
          underline: SizedBox(),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          style: theme.textTheme.labelMedium!.copyWith(
            color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white
          ),
        )),
    );
  }

  final lengths = [25, 40, 50, 75, 100, 150, 200];
  _buildRecentsSongLimit(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Iconify(EosIcons.counting),
      title: Text("Recents Songs Count"),
      subtitle: Text("Set how many songs you want to save in recents"),
      trailing: Obx(() => DropdownButton(
          value: controller.getRecentsSavedLength,
          items: lengths.map((item) => DropdownMenuItem(value: item, child: Text("$item"))).toList(),
          onChanged: (newValue) async {
            controller.setRecentsSavedLength = lengths[lengths.indexOf(newValue!)];
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt(PrefsKey.recentsLength, controller.getRecentsSavedLength);
          },
          icon: Iconify(MaterialSymbols.arrow_drop_down_rounded,),
          padding: EdgeInsets.zero,
          underline: SizedBox(),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          style: theme.textTheme.labelMedium!.copyWith(
            color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white
          ),
        )),
    );
  }
}