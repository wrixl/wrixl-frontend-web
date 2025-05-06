// lib/screens/dashboard/activity_screen.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('Activity & Alerts'),
        elevation: 0,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final layout = LayoutHelper.fromDimensions(constraints.maxWidth, constraints.maxHeight);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: LayoutHelper.fixedOuterScreenMargin, vertical: 24),
          child: Column(
            children: [
              Row(
                children: [
                  WrixlCard(
                    width: layout.halfColumnWidth,
                    height: layout.tallHeight,
                    openOnTap: true,
                    modalSize: ModalSize.large,
                    modalTitle: "Notifications",
                    child: const Text("Notifications Feed Placeholder"),
                  ),
                  SizedBox(width: layout.cardGutter),
                  WrixlCard(
                    width: layout.halfColumnWidth,
                    height: layout.tallHeight,
                    openOnTap: true,
                    modalSize: ModalSize.large,
                    modalTitle: "Transactions",
                    child: const Text("Transaction History Placeholder"),
                  ),
                ],
              ),
              SizedBox(height: layout.verticalRowSpacing),
              WrixlCard(
                width: layout.threeColumnWidth,
                height: layout.mediumHeight,
                openOnTap: true,
                modalSize: ModalSize.large,
                modalTitle: "Upcoming Events",
                child: const Text("Upcoming Events Placeholder"),
              ),
              SizedBox(height: layout.verticalRowSpacing),
              Row(
                children: [
                  WrixlCard(
                    width: layout.halfColumnWidth,
                    height: layout.shortHeight,
                    openOnTap: true,
                    modalSize: ModalSize.medium,
                    modalTitle: "Claimable Airdrops",
                    child: const Text("Claimable Airdrops Placeholder"),
                  ),
                  SizedBox(width: layout.cardGutter),
                  WrixlCard(
                    width: layout.halfColumnWidth,
                    height: layout.shortHeight,
                    openOnTap: true,
                    modalSize: ModalSize.medium,
                    modalTitle: "AI Alerts",
                    child: const Text("AI Insight Cards Placeholder"),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity & Alerts'),
        elevation: 0,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final layout = LayoutHelper.fromDimensions(constraints.maxWidth, constraints.maxHeight);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: LayoutHelper.fixedOuterScreenMargin, vertical: 24),
          child: Wrap(
            spacing: layout.cardGutter,
            runSpacing: layout.verticalRowSpacing,
            children: [
              WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.tallHeight,
                openOnTap: true,
                modalSize: ModalSize.large,
                modalTitle: "Notifications",
                child: const Text("Notifications Feed Placeholder"),
              ),
              WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.tallHeight,
                openOnTap: true,
                modalSize: ModalSize.large,
                modalTitle: "Transactions",
                child: const Text("Transaction History Placeholder"),
              ),
              WrixlCard(
                width: layout.twoColumnWidth,
                height: layout.mediumHeight,
                openOnTap: true,
                modalSize: ModalSize.large,
                modalTitle: "Upcoming Events",
                child: const Text("Upcoming Events Placeholder"),
              ),
              WrixlCard(
                width: layout.twoColumnWidth,
                height: layout.shortHeight,
                openOnTap: true,
                modalSize: ModalSize.medium,
                modalTitle: "Claimable Airdrops",
                child: const Text("Claimable Airdrops Placeholder"),
              ),
              WrixlCard(
                width: layout.twoColumnWidth,
                height: layout.shortHeight,
                openOnTap: true,
                modalSize: ModalSize.medium,
                modalTitle: "AI Alerts",
                child: const Text("AI Insight Cards Placeholder"),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity & Alerts'),
        elevation: 0,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final layout = LayoutHelper.fromDimensions(constraints.maxWidth, constraints.maxHeight);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: LayoutHelper.fixedOuterScreenMargin, vertical: 24),
          child: Column(
            children: [
              WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.mediumHeight,
                openOnTap: true,
                modalSize: ModalSize.medium,
                modalTitle: "Notifications",
                child: const Text("Notifications Feed Placeholder"),
              ),
              SizedBox(height: layout.verticalRowSpacing),
              WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.mediumHeight,
                openOnTap: true,
                modalSize: ModalSize.medium,
                modalTitle: "Transactions",
                child: const Text("Transaction History Placeholder"),
              ),
              SizedBox(height: layout.verticalRowSpacing),
              WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.mediumHeight,
                openOnTap: true,
                modalSize: ModalSize.medium,
                modalTitle: "Upcoming Events",
                child: const Text("Upcoming Events Placeholder"),
              ),
              SizedBox(height: layout.verticalRowSpacing),
              WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.shortHeight,
                openOnTap: true,
                modalSize: ModalSize.small,
                modalTitle: "Claimable Airdrops",
                child: const Text("Claimable Airdrops Placeholder"),
              ),
              SizedBox(height: layout.verticalRowSpacing),
              WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.shortHeight,
                openOnTap: true,
                modalSize: ModalSize.small,
                modalTitle: "AI Alerts",
                child: const Text("AI Insight Cards Placeholder"),
              ),
            ],
          ),
        );
      }),
    );
  }
}