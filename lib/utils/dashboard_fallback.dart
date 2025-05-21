// lib\utils\dashboard_fallback.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dashboard/dashboard.dart';
import 'dashboard_item_extensions.dart';

Future<List<DashboardItem>> loadOrCreateFallbackLayout({
  required String screenId,
  required String userId,
  required String preset,
  required String deviceClass,
  required List<DashboardItem> defaultItems,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final key = '${screenId}_${userId}_${preset}_${deviceClass}_layout';
  final existing = prefs.getString(key);
  if (existing != null) return [];

  final encoded = defaultItems.map((w) => w.toJson()).toList();
  await prefs.setString(key, json.encode(encoded));
  return defaultItems;
}
