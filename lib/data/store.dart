import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value); 
  }

  static Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return saveString(key, jsonEncode(value));
  }

  static Future<String> getString(String key, [String defaultValue = '']) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future getMap(String key) async {
    
    final keyString = await getString(key);

    if (keyString.isEmpty) return;

    try {
      Map<String, dynamic> json = jsonDecode(keyString);
      return json;
    } catch (e) {
      print('getMap erro = ${e.toString()}');
      return {};
    }
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}