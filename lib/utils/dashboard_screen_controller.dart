// lib\utils\dashboard_screen_controller.dart

import 'dart:convert';
import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrixl_frontend/utils/dashboard_item_extensions.dart';
import 'package:wrixl_frontend/utils/dashboard_item_storage_delegate.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/utils/user_utils.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';

class DashboardScreenController {
  final String screenId;
  final String preset;
  final BuildContext context;
  final List<DashboardItem> Function(DeviceSizeClass sizeClass) getDefaultItems;

  late final SharedPrefsDashboardStorage storage;
  late final DashboardItemController<DashboardItem> controller;
  late final DeviceSizeClass deviceClass;
  late final String deviceClassStr;
  late final String userId;
  final Map<String, bool> visibility = {};

  DashboardScreenController({
    required this.screenId,
    required this.preset,
    required this.context,
    required this.getDefaultItems,
  });

  Future<void> initialize() async {
    userId = await getOrCreateUserId();
    deviceClass = _getSizeClass(context);
    deviceClassStr = deviceClass.name;

    final fallback = preset == 'Custom'
        ? await _getCustomFallback()
        : getDefaultItems(deviceClass);

    storage = SharedPrefsDashboardStorage(
      screenId: screenId,
      userId: userId,
      presetName: preset,
      deviceClass: deviceClassStr,
      fallbackBuilder: () => fallback,
    );

    controller =
        DashboardItemController.withDelegate(itemStorageDelegate: storage);
    storage.controller = controller;

    controller.addListener(() async {
      if (preset == 'Custom') {
        final allItems = await storage.getAllItems(12);
        for (final item in allItems) {
          item.layoutData;
        }
        await storage.onItemsUpdated(allItems, 12);
      }
    });

    final items = await controller.itemStorageDelegate!.getAllItems(12);
    controller.notifyItemsChangedExternally(items);

    final vis = await storage.loadVisibility();
    visibility.addAll(vis);

    await storage.logSavedLayout();
  }

  Future<List<DashboardItem>> _getCustomFallback() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '{screenId}_{userId}_Custom_{deviceClassStr}_layout';
    final existing = prefs.getString(key);
    if (existing != null) return [];

    final defaultItems = getDefaultItems(deviceClass);
    final encoded = defaultItems.map((w) => w.toJson()).toList();
    await prefs.setString(key, json.encode(encoded));
    return defaultItems;
  }

  DeviceSizeClass _getSizeClass(BuildContext context) {
    if (Responsive.isMobile(context)) return DeviceSizeClass.mobile;
    if (Responsive.isTablet(context)) return DeviceSizeClass.tablet;
    return DeviceSizeClass.desktop;
  }

  bool isVisible(String id) => visibility[id] ?? true;

  void toggleVisibility(String id) {
    visibility[id] = !(visibility[id] ?? true);
    storage.saveVisibility(visibility);
  }
}
