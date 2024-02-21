import 'package:shared_preferences/shared_preferences.dart';

class LastSessionSprefs {
  LastSessionSprefs._();

  static const String _key = 'lastSession';
  static List<String> _addedSongIds = [];

  static Future<void> _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_key, _addedSongIds);
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

  static Future<void> add(String id) async {
    List<String> currentIndices = await load();
    if (currentIndices.contains(id)) {
      currentIndices.removeAt(currentIndices.indexOf(id));
    }
    _addedSongIds = currentIndices;
    _addedSongIds.add(id);
    if(_addedSongIds.length > 50) {
      _addedSongIds.removeAt(0);
    }
    await _save();
  }
}