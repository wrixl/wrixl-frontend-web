// lib\utils\screen_layout_storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/dashboard_item_extensions.dart'; // import the extension

class DashboardItemLayoutStorage {
  static Future<void> savePreset(String name, List<DashboardItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString("preset_$name", jsonEncode(jsonList));
  }

  static Future<List<DashboardItem>?> loadPreset(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("preset_$name");
    if (jsonString == null) return null;

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => dashboardItemFromJson(json)).toList();
  }

  static Future<void> deletePreset(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("preset_$name");
  }
}
