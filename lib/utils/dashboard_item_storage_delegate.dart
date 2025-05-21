// lib\utils\dashboard_item_storage_delegate.dart

import 'dart:async';
import 'dart:convert';
import 'package:dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrixl_frontend/utils/dashboard_item_extensions.dart';

class SharedPrefsDashboardStorage
    extends DashboardItemStorageDelegate<DashboardItem> {
  final String screenId;
  final String userId;
  final String presetName;
  final List<DashboardItem> Function()? fallbackBuilder;
  final String deviceClass; // "desktop", "tablet", or "mobile"
  late final String layoutKey;
  late final String visibilityKey;

  DashboardItemController<DashboardItem>? controller;

  SharedPrefsDashboardStorage({
    required this.screenId,
    required this.userId,
    required this.presetName,
    required this.deviceClass,
    this.fallbackBuilder,
  }) {
    layoutKey = '${screenId}_${userId}_${presetName}_${deviceClass}_layout';
    visibilityKey =
        '${screenId}_${userId}_${presetName}_${deviceClass}_visibility';
  }

  @override
  bool get cacheItems => true;

  @override
  bool get layoutsBySlotCount => false;

  @override
  FutureOr<List<DashboardItem>> getAllItems(int slotCount) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(layoutKey);

    if (jsonString != null) {
      final decoded = json.decode(jsonString) as List;
      return decoded.map((itemJson) {
        final item = dashboardItemFromJson(itemJson as Map<String, dynamic>);
        item.layoutData ??=
            ItemLayout(startX: 0, startY: 0, width: 12, height: 3);
        return item;
      }).toList();
    }

    final fallback = fallbackBuilder?.call() ?? [];
    await onItemsUpdated(fallback, slotCount);
    return fallback;
  }

  Future<void> logSavedLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(layoutKey);
    print('[DEBUG] Current saved layout ($layoutKey): $jsonString');
  }

  @override
  Future<void> onItemsUpdated(List<DashboardItem> items, int slotCount) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(layoutKey);

    List<Map<String, dynamic>> saved = [];
    if (raw != null) {
      try {
        saved = (json.decode(raw) as List).cast<Map<String, dynamic>>();
      } catch (_) {}
    }
    if (saved.isEmpty && fallbackBuilder != null) {
      saved = fallbackBuilder!().map((w) => w.toJson()).toList();
    }

    final indexOf = <String, int>{};
    for (var i = 0; i < saved.length; i++) {
      indexOf[saved[i]['identifier'] as String] = i;
    }

    for (final w in items) {
      final jsonMap = w.toJson();
      final idx = indexOf[w.identifier];
      if (idx != null) {
        saved[idx] = jsonMap;
      } else {
        saved.add(jsonMap);
      }
    }

    final merged = json.encode(saved);
    await prefs.setString(layoutKey, merged);
    print('[SharedPrefsStorage] onItemsUpdated for key $layoutKey: $merged');
  }

  @override
  Future<void> onItemsAdded(List<DashboardItem> newItems, int slotCount) async {
    final existingItems = await getAllItems(slotCount);
    final updatedItems = [...existingItems, ...newItems];
    print(
        '[SharedPrefsStorage] onItemsAdded: ${newItems.map((i) => i.identifier).toList()}');
    await onItemsUpdated(updatedItems, slotCount);
  }

  @override
  Future<void> onItemsDeleted(
      List<DashboardItem> removedItems, int slotCount) async {
    final existingItems = await getAllItems(slotCount);
    final updatedItems =
        existingItems.where((item) => !removedItems.contains(item)).toList();
    print(
        '[SharedPrefsStorage] onItemsDeleted: ${removedItems.map((i) => i.identifier).toList()}');
    await onItemsUpdated(updatedItems, slotCount);
  }

  Future<void> saveVisibility(Map<String, bool> visibilityMap) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(visibilityMap);
    await prefs.setString(visibilityKey, encoded);
    print(
        '[SharedPrefsStorage] saved visibility for key $visibilityKey: $encoded');
  }

  Future<Map<String, bool>> loadVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(visibilityKey);
    if (jsonString == null) return {};
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as bool));
  }
}
