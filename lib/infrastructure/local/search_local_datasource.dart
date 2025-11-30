import 'package:shared_preferences/shared_preferences.dart';

class SearchLocalDatasource {
  static const String keyRecent = "recent_searches";

  Future<List<String>> getRecent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyRecent) ?? [];
  }

  Future<void> addRecent(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(keyRecent) ?? [];

    if (keyword.trim().isEmpty) return;

    // Hapus duplikat
    current.remove(keyword);

    // Masukkan paling depan
    current.insert(0, keyword);

    // Maksimal 10 histori
    final limited = current.take(10).toList();

    await prefs.setStringList(keyRecent, limited);
  }

  Future<void> clearRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyRecent);
  }
}
