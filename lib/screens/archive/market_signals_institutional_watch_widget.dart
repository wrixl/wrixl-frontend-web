// lib\widgets\screen_specific_widgets\market_signals_widgets\market_signals_institutional_watch_widget.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

/// Data model for an institutional announcement.
class InstitutionalAnnouncement {
  final String entityName;
  final String activityType; // e.g., "ETF news", "Token allocations", "Disclosures"
  final IconData icon;
  final String? badge; // e.g., "High Impact" or "Neutral"
  final String details; // Detailed text for modal

  InstitutionalAnnouncement({
    required this.entityName,
    required this.activityType,
    required this.icon,
    this.badge,
    required this.details,
  });
}

/// Institutional Watch widget renders a horizontally scrollable list of announcement cards,
/// with a filter toggle row at the top using our reusable ToggleFilterIconRowWidget.
class MarketSignalsInstitutionalWatchWidget extends StatefulWidget {
  final List<InstitutionalAnnouncement> announcements;

  const MarketSignalsInstitutionalWatchWidget({
    Key? key,
    required this.announcements,
  }) : super(key: key);

  @override
  _MarketSignalsInstitutionalWatchWidgetState createState() =>
      _MarketSignalsInstitutionalWatchWidgetState();
}

class _MarketSignalsInstitutionalWatchWidgetState
    extends State<MarketSignalsInstitutionalWatchWidget> {
  String selectedFilter = "All";

  // Filter options and their icons.
  final List<String> filters = ["All", "ETF news", "Token allocations", "Disclosures"];
  final Map<String, IconData> filterIcons = {
    "All": Icons.all_inclusive,
    "ETF news": Icons.document_scanner,
    "Token allocations": Icons.pie_chart,
    "Disclosures": Icons.report,
  };

  /// Filters announcements based on the selected filter value.
  List<InstitutionalAnnouncement> get filteredAnnouncements {
    if (selectedFilter == "All") return widget.announcements;
    return widget.announcements.where((announcement) {
      return announcement.activityType.toLowerCase() ==
          selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use our reusable Toggle Filter widget for institutional watch.
        ToggleFilterIconRowWidget(
          options: filters,
          optionIcons: filterIcons,
          activeOption: selectedFilter,
          onSelected: (option) {
            setState(() {
              selectedFilter = option;
            });
          },
        ),
        const SizedBox(height: 12),
        // Horizontal list of announcement cards.
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filteredAnnouncements.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final announcement = filteredAnnouncements[index];
              return GestureDetector(
                onTap: () {
                  // Expand into detailed modal with graphs and suggested actions.
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(announcement.entityName),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Activity: ${announcement.activityType}"),
                          const SizedBox(height: 8),
                          // Placeholder for graphs and historic trends.
                          Text("Historical trend graphs would appear here."),
                          const SizedBox(height: 8),
                          Text("Suggested action: Rotate 5% into AI if holding <10%."),
                          const SizedBox(height: 8),
                          Text("Link to source or analysis..."),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  color: AppConstants.primaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppConstants.accentColor.withOpacity(0.4)),
                  ),
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon for the announcement.
                        Icon(announcement.icon, color: AppConstants.accentColor, size: 30),
                        const SizedBox(width: 10),
                        // Announcement details.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                announcement.entityName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppConstants.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                announcement.activityType,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppConstants.secondaryTextColor,
                                    ),
                              ),
                              const Spacer(),
                              // Optional badge for impact or sentiment.
                              if (announcement.badge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: announcement.badge == "High Impact"
                                        ? Colors.red
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    announcement.badge!,
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
