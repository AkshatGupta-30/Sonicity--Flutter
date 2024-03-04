// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/radix_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonicity/src/controllers/settings_controller.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/contants/fonts.dart';
import 'package:sonicity/utils/contants/prefs_keys.dart';
import 'package:sonicity/utils/sections/title_section.dart';
import 'package:sonicity/utils/widgets/style_widget.dart';

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
            ],
          ),
        ),
      ),
    );
  }

  final dropDownValue = "System".obs;
  Obx _buildTheme(BuildContext context) {
    return Obx(() {
      dropDownValue.value = (controller.getThemeMode == ThemeMode.system) 
        ? "System"
        : (controller.getThemeMode == ThemeMode.light) ? "Light Mode" : "Dark Mode";
      ThemeData theme = Theme.of(context);
      return ListTile(
      leading: Iconify(
        (controller.getThemeMode == ThemeMode.system)
          ? Mdi.theme_light_dark
          : (controller.getThemeMode == ThemeMode.light)
            ? Ic.twotone_wb_sunny
            : Ph.moon_stars_duotone,
        color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white
      ),
      title: Text(
        "Theme Mode",
        style: theme.textTheme.labelMedium!.copyWith(
          color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
        ),
      ),
      trailing: DropdownButton(
        value: dropDownValue.value,
        items: ["System" , "Light Mode", "Dark Mode"].map(
          (item) => DropdownMenuItem(value: item, child: Text(item))
        ).toList(),
        onChanged: (newValue) async {
          if(newValue == "System") {controller.setThemeMode = ThemeMode.system;}
          else if(newValue == "Light Mode") {controller.setThemeMode = ThemeMode.light;}
          else {controller.setThemeMode = ThemeMode.dark;}
          dropDownValue.value = newValue!;
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(PrefsKey.themeMode, dropDownValue.value);
        },
        icon: Iconify(
          Ic.twotone_arrow_drop_down_circle,
          color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
        ),
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

  final fontChange = false.obs;
  ListTile _buildFont(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Iconify(RadixIcons.font_family, color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white),
      title: Text("Font Family"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text("Abc"), Iconify(MaterialSymbols.arrow_right_rounded, color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white)]
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
                      if(controller.fontFamily.value == font) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(PrefsKey.fontFamily, font);
                        controller.setFontfamily = font;
                      }
                      Navigator.pop(context);
                      Get.showSnackbar(
                        GetSnackBar(title: "Info", message: "New setting will be applied on app restart", duration: Duration(seconds: 2),)
                      );
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
}