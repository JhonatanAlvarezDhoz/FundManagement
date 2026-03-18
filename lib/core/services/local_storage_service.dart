import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> save(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(data));
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    if (value == null) return null;
    return jsonDecode(value);
  }
}
