import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';
import 'package:wrixl_frontend/utils/responsive.dart';

class DashboardScreen2 extends StatelessWidget {
  const DashboardScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return _buildDesktopLayout();
    } else if (Responsive.isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Wrixl Dashboard"),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layout = LayoutHelper.fromDimensions(constraints.maxWidth, constraints.maxHeight);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: LayoutHelper.fixedOuterScreenMargin, vertical: 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WrixlCard(
                      width: layout.twoColumnWidth,
                      height: layout.tallHeight,
                      openOnTap: true,
                      modalSize: ModalSize.large,
                      modalTitle: "Portfolio Snapshot",
                      child: const Text("Portfolio Snapshot Placeholder"),
                    ),
                    SizedBox(width: layout.cardGutter),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WrixlCard(
                          width: layout.oneColumnWidth,
                          height: layout.mediumHeight,
                          stacked: true,
                          openOnTap: true,
                          modalSize: ModalSize.medium,
                          modalTitle: "Performance Benchmarks",
                          child: const Text("Performance vs Benchmarks Placeholder"),
                        ),
                        SizedBox(height: layout.verticalRowSpacing),
                        WrixlCard(
                          width: layout.oneColumnWidth,
                          height: layout.shortHeight,
                          stacked: true,
                          openOnTap: true,
                          modalSize: ModalSize.small,
                          modalTitle: "Next Best Action",
                          child: const Text("Next Best Action Placeholder"),
                        ),
                        SizedBox(height: layout.verticalRowSpacing),
                        WrixlCard(
                          width: layout.oneColumnWidth,
                          height: layout.shortHeight,
                          stacked: true,
                          openOnTap: true,
                          modalSize: ModalSize.small,
                          modalTitle: "AI Quick Tip",
                          child: const Text("AI Quick Tip Placeholder"),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: layout.verticalRowSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WrixlCard(
                      width: layout.oneColumnWidth,
                      height: layout.mediumHeight,
                      openOnTap: true,
                      modalSize: ModalSize.medium,
                      modalTitle: "Smart Money Drift",
                      child: const Text("Smart Money Drift Placeholder"),
                    ),
                    SizedBox(width: layout.cardGutter),
                    WrixlCard(
                      width: layout.twoColumnWidth,
                      height: layout.mediumHeight,
                      openOnTap: true,
                      modalSize: ModalSize.large,
                      modalTitle: "Token Allocation",
                      child: const Text("Token Allocation Breakdown Placeholder"),
                    ),
                  ],
                ),
                SizedBox(height: layout.verticalRowSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WrixlCard(
                      width: layout.halfColumnWidth,
                      height: layout.moderateHeight,
                      openOnTap: true,
                      modalSize: ModalSize.medium,
                      modalTitle: "Portfolio Stress Radar",
                      child: const Text("Portfolio Stress Radar Placeholder"),
                    ),
                    SizedBox(width: layout.cardGutter),
                    WrixlCard(
                      width: layout.halfColumnWidth,
                      height: layout.moderateHeight,
                      openOnTap: true,
                      modalSize: ModalSize.medium,
                      modalTitle: "Smart Money Live Ticker",
                      child: const Text("Smart Money Live Ticker Placeholder"),
                    ),
                  ],
                ),
                SizedBox(height: layout.verticalRowSpacing),
                WrixlCard(
                  width: layout.threeColumnWidth,
                  height: layout.mediumHeight,
                  openOnTap: true,
                  modalSize: ModalSize.fullscreen,
                  modalTitle: "Model Portfolios",
                  child: const Text("Model Portfolios Carousel Placeholder"),
                ),
                SizedBox(height: layout.verticalRowSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WrixlCard(
                      width: layout.twoColumnWidth,
                      height: layout.mediumHeight,
                      openOnTap: true,
                      modalSize: ModalSize.medium,
                      modalTitle: "Alerts and Events",
                      child: const Text("Alerts + Events Placeholder"),
                    ),
                    SizedBox(width: layout.cardGutter),
                    WrixlCard(
                      width: layout.oneColumnWidth,
                      height: layout.mediumHeight,
                      openOnTap: true,
                      modalSize: ModalSize.small,
                      modalTitle: "Wrixler Rank",
                      child: const Text("Wrixler Rank + Shareable Card Placeholder"),
                    ),
                  ],
                ),
                SizedBox(height: layout.verticalRowSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WrixlCard(
                      width: layout.halfColumnWidth,
                      height: layout.mediumHeight,
                      openOnTap: true,
                      modalSize: ModalSize.medium,
                      modalTitle: "Missed Opportunities",
                      child: const Text("Missed Opportunities Placeholder"),
                    ),
                    SizedBox(width: layout.cardGutter),
                    WrixlCard(
                      width: layout.halfColumnWidth,
                      height: layout.mediumHeight,
                      openOnTap: true,
                      modalSize: ModalSize.medium,
                      modalTitle: "Streak Tracker",
                      child: const Text("Streak Tracker / Milestones Placeholder"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabletLayout() {
    return _buildDesktopLayout();
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Wrixl Dashboard"),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layout = LayoutHelper.fromDimensions(constraints.maxWidth, constraints.maxHeight);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: LayoutHelper.fixedOuterScreenMargin, vertical: 24),
            child: Column(
              children: [
                ...[
                  "Portfolio Snapshot",
                  "Smart Money Drift",
                  "Performance Benchmarks",
                  "Next Best Action",
                  "AI Quick Tip",
                  "Model Portfolios",
                  "Token Allocation",
                  "Stress Radar",
                  "Live Ticker",
                  "Alerts",
                  "Wrixler Rank",
                  "Missed Opportunities",
                  "Streak Tracker",
                ].map((title) => Padding(
                      padding: EdgeInsets.only(bottom: layout.verticalRowSpacing),
                      child: WrixlCard(
                        width: layout.oneColumnWidth,
                        height: layout.mediumHeight,
                        openOnTap: true,
                        modalSize: ModalSize.medium,
                        modalTitle: title,
                        child: Text("$title Placeholder"),
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}