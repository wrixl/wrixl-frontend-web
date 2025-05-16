// lib\utils\widget_layout_storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrixl_frontend/screens/archive/reusable_widget_layout_card.dart';

class WidgetLayoutStorage {
  static Future<void> savePreset(
      String presetName, List<WidgetLayout> layouts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = layouts.map((e) => e.toJson()).toList();
    await prefs.setString('preset_' + presetName, jsonEncode(jsonList));
  }

  static Future<List<WidgetLayout>?> loadPreset(String presetName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('preset_' + presetName);
    if (jsonString == null) return null;

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => WidgetLayout.fromJson(e)).toList();
  }

  static Future<void> deletePreset(String presetName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('preset_' + presetName);
  }
}
