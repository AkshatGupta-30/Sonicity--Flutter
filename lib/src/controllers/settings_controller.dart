import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/contants/fonts.dart';
import 'package:sonicity/utils/contants/prefs_keys.dart';

class SettingsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initThemeMode();
    _initAccent();
    _initFontFamily();
    _initBackGround();
    _initDensePlayer();
  }

  final _themeModeSaved = ThemeMode.system.obs;
  ThemeMode get getThemeMode => _themeModeSaved.value;
  set setThemeMode(ThemeMode newThemeMode) => _themeModeSaved.value = newThemeMode;
  void _initThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    String selection = prefs.getString(PrefsKey.themeMode) ?? "System";
    if(selection == "System") {setThemeMode = ThemeMode.system;}
    else if(selection == "Light Mode") {setThemeMode = ThemeMode.light;}
    else {setThemeMode = ThemeMode.dark;}
  }

  final _accentIndex = 0.obs;
  int get getAccentIndex => _accentIndex.value;
  Color get getAccent => lightColorList[_accentIndex.value];
  Color get getAccentDark => darkColorList[_accentIndex.value];
  set setAccentIndex(int index) => _accentIndex.value = index;
  void _initAccent() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt(PrefsKey.accentIndex) ?? 0;
    setAccentIndex = index;
  }

  final fontFamily = Fonts.lovelyMamma.obs;
  set setFontfamily(String newFont) => fontFamily.value = newFont;
  void _initFontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    String selection = prefs.getString(PrefsKey.fontFamily) ?? Fonts.lovelyMamma;
    setFontfamily = selection;
  }

  final _backGround = 0.obs;
  int get getBackGround => _backGround.value;
  set setBackground(int index) => _backGround.value = index;
  void _initBackGround() async {
    final prefs = await SharedPreferences.getInstance();
    int selection = prefs.getInt(PrefsKey.backGradient) ?? 0;
    setBackground = selection;
  }

  final _useDensePlayer = false.obs;
  bool get getDensePlayer => _useDensePlayer.value;
  set setDensePlayer(bool value) => _useDensePlayer.value = value;
  void _initDensePlayer() async {
    final prefs = await SharedPreferences.getInstance();
    bool selection = prefs.getBool(PrefsKey.useDensePlayer) ?? false;
    setDensePlayer = selection;
  }
}