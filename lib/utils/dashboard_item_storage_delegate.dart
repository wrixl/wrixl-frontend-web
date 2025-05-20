// lib\utils\dashboard_item_storage_delegate.dart

import 'dart:async';
import 'dart:convert';
import 'package:dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrixl_frontend/utils/dashboard_item_extensions.dart';

class SharedPrefsDashboardStorage
    extends DashboardItemStorageDelegate<DashboardItem> {
  final String storageKey;
  final String visibilityKey;
  final List<DashboardItem> Function()? fallbackBuilder;
  DashboardItemController<DashboardItem>? controller;

  SharedPrefsDashboardStorage(this.storageKey, this.visibilityKey,
      {this.fallbackBuilder});

  @override
  bool get cacheItems => true;

  @override
  bool get layoutsBySlotCount => false;

  @override
  FutureOr<List<DashboardItem>> getAllItems(int slotCount) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(storageKey);

    if (jsonString != null) {
      final decoded = json.decode(jsonString) as List;
      return decoded.map((itemJson) {
        final item = dashboardItemFromJson(itemJson as Map<String, dynamic>);
        item.layoutData ??=
            ItemLayout(startX: 0, startY: 0, width: 12, height: 3);
        return item;
      }).toList();
    }

    // Only fallback if nothing exists, and persist it!
    final fallback = fallbackBuilder?.call() ?? [];
    await onItemsUpdated(fallback, slotCount); // 💾 persist fallback!
    return fallback;
  }

  Future<void> logSavedLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('activity_layout');
    print('[DEBUG] Current saved layout: $jsonString');
  }

  @override
  Future<void> onItemsUpdated(List<DashboardItem> items, int slotCount) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    // 1) decode existing JSON (or start from fallback)
    List<Map<String, dynamic>> saved = [];
    if (raw != null) {
      try {
        saved = (json.decode(raw) as List).cast<Map<String, dynamic>>();
      } catch (_) {}
    }
    if (saved.isEmpty && fallbackBuilder != null) {
      saved = fallbackBuilder!().map((w) => w.toJson()).toList();
    }

    // 2) build a map of identifier → index in that list
    final indexOf = <String, int>{};
    for (var i = 0; i < saved.length; i++) {
      indexOf[saved[i]['identifier'] as String] = i;
    }

    // 3) for each widget we’re handed, overwrite its slot in that list (or append)
    for (final w in items) {
      final jsonMap = w.toJson();
      final idx = indexOf[w.identifier];
      if (idx != null) {
        saved[idx] = jsonMap;
      } else {
        saved.add(jsonMap);
      }
    }

    // 4) write back the full list
    final merged = json.encode(saved);
    await prefs.setString(storageKey, merged);
    print('[SharedPrefsStorage] onItemsUpdated: $merged');
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
  }

  Future<Map<String, bool>> loadVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(visibilityKey);
    if (jsonString == null) return {};
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as bool));
  }
}
