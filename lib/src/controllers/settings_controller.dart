import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonicity/utils/contants/colors.dart';

class SettingsController extends GetxController {
  final _themeModeSaved = ThemeMode.system.obs;
  ThemeMode get getThemeMode => _themeModeSaved.value;
  set setThemeMode(ThemeMode newThemeMode) => _themeModeSaved.value = newThemeMode;

  final _accentIndex = 0.obs;
  int get getAccentIndex => _accentIndex.value;
  Color get getAccent => lightColorList[_accentIndex.value];
  Color get getAccentDark => darkColorList[_accentIndex.value];
  set setAccentIndex(int index) => _accentIndex.value = index;

  @override
  void onInit() {
    super.onInit();
    _initThemeMode();
    _initAccent();
  }

  _initThemeMode() {
    final selection = Settings.getValue<int>('theme-mode');
    if(selection == 1) {setThemeMode = ThemeMode.system;}
    else if(selection == 2) {setThemeMode = ThemeMode.light;}
    else {setThemeMode = ThemeMode.dark;}
  }

  _initAccent() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('accent-index') ?? 0;
    _accentIndex.value = index;
  }
}