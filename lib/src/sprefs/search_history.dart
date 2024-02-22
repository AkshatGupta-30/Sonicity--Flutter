import 'package:shared_preferences/shared_preferences.dart';

class SearchHistorySprefs {
  static const String _key = 'searchHistory';

  static Future<void> save(List<String> history) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_key, history);
  }

  static Future<List<String>> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList(_key);
    if(history == null){
      return [];
    }
    return history;
  }
}
