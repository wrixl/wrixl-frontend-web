// lib/utils/dashboard_item_extensions.dart

import 'package:dashboard/dashboard.dart';

extension DashboardItemSerialization on DashboardItem {
  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'width': layoutData.width ?? 1,
        'height': layoutData.height ?? 1,
        'startX': layoutData.startX ?? 0,
        'startY': layoutData.startY ?? 0,
      };
}

DashboardItem dashboardItemFromJson(Map<String, dynamic> json) {
  return DashboardItem(
    identifier: json['identifier'],
    width: json['width'],
    height: json['height'],
    startX: json['startX'],
    startY: json['startY'],
  );
}
