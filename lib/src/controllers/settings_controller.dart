import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final _themeModeSaved = ThemeMode.system.obs;
  ThemeMode get getThemeMode => _themeModeSaved.value;
  set setThemeMode(ThemeMode newThemeMode) => _themeModeSaved.value = newThemeMode;

  @override
  void onInit() {
    super.onInit();
    _initThemeMode();
  }

  _initThemeMode() {
    final selection = Settings.getValue<int>('theme-mode');
    if(selection == 1) {setThemeMode = ThemeMode.system;}
    else if(selection == 2) {setThemeMode = ThemeMode.light;}
    else {setThemeMode = ThemeMode.dark;}
  }
}