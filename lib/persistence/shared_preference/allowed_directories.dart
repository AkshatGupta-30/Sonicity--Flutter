// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class AllowedDirectories {
  AllowedDirectories._();

  static const String _key = 'allowedDirectory';
  static List<String> allowedDirectory = [];

  static Future<void> _save() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(_key, allowedDirectory);
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future<List<String>> load() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? indexStrings = prefs.getStringList(_key);
      List<String> indices = indexStrings ?? [];
      return indices;
    } catch (e) {
      return [];
    }
  }

  static Future<void> update(String path, {required bool isAdded}) async {
    List<String> currentIndices = await load();
    if (isAdded) {
      if (!currentIndices.contains(path)) {
        allowedDirectory = currentIndices;
        allowedDirectory.add(path);
        await _save();
      }
    } else {
      currentIndices.remove(path);
      allowedDirectory = currentIndices;
      await _save();
    }
  }
}