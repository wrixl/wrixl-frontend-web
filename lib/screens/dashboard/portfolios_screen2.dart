// lib/screens/dashboard/portfolios_screen2.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';

class PortfoliosScreen2 extends StatefulWidget {
  const PortfoliosScreen2({Key? key}) : super(key: key);

  @override
  State<PortfoliosScreen2> createState() => _PortfoliosScreen2State();
}

class _PortfoliosScreen2State extends State<PortfoliosScreen2>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Mine'),
    Tab(text: 'Popular'),
    Tab(text: 'Build'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: const Text('Portfolios'),
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layout = LayoutHelper.fromDimensions(
              constraints.maxWidth, constraints.maxHeight);
          return TabBarView(
            controller: _tabController,
            children: [
              _desktopMyPortfolios(layout),
              _desktopModelPortfolios(layout),
              _desktopBuildStrategy(layout),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_chart_rounded),
        label: const Text("Build Portfolio"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          _tabController.animateTo(2); // Switch to Build tab
        },
      ),
    );
  }

Widget _buildTabletLayout() {
  return _buildDesktopLayout(); // Shares same structure for now
}


  Widget _desktopMyPortfolios(LayoutHelper layout) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LayoutHelper.fixedOuterScreenMargin),
      child: Wrap(
        spacing: layout.cardGutter,
        runSpacing: layout.verticalRowSpacing,
        children: [
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.shortHeight,
            openOnTap: false,
            modalSize: ModalSize.medium,
            modalTitle: "Portfolio View Filters",
            child: const Text("Tabs: Live | Simulated | Archived Placeholder"),
          ),
          WrixlCard(
            width: layout.oneColumnWidth,
            height: layout.tallHeight,
            openOnTap: true,
            modalSize: ModalSize.medium,
            modalTitle: "Filters",
            child: const Text("Sidebar Filters Placeholder"),
          ),
          ...List.generate(4, (i) {
            return WrixlCard(
              width: layout.oneColumnWidth,
              height: layout.mediumHeight,
              openOnTap: true,
              modalSize: ModalSize.medium,
              modalTitle: "Portfolio ${i + 1}",
              child: const Text("Portfolio Card Placeholder"),
            );
          }),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.mediumHeight,
            openOnTap: true,
            modalSize: ModalSize.large,
            modalTitle: "Portfolio Detail",
            child: const Text("Portfolio Detail Placeholder"),
          ),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.mediumHeight,
            openOnTap: true,
            modalSize: ModalSize.large,
            modalTitle: "Portfolio Comparison Radar",
            child: const Text("Comparison Radar Chart Placeholder"),
          ),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.shortHeight,
            openOnTap: true,
            modalSize: ModalSize.medium,
            modalTitle: "Create Portfolio",
            child: Center(
              child: Text("➕ Create New Portfolio Placeholder"),
            ),
          ),
        ],
      ),
    );
  }


  Widget _desktopModelPortfolios(LayoutHelper layout) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LayoutHelper.fixedOuterScreenMargin),
      child: Column(
        children: [
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.shortHeight,
            openOnTap: false,
            modalSize: ModalSize.medium,
            modalTitle: "Model Filters",
            child: const Text("Filters: Risk-Off | Yield | Smart Money | AI | ..."),
          ),
          SizedBox(height: layout.verticalRowSpacing),
          Wrap(
            spacing: layout.cardGutter,
            runSpacing: layout.verticalRowSpacing,
            children: List.generate(4, (i) {
              return WrixlCard(
                width: layout.oneColumnWidth,
                height: layout.mediumHeight,
                openOnTap: true,
                modalSize: ModalSize.medium,
                modalTitle: "Model Portfolio ${i + 1}",
                child: const Text("Model Portfolio Card Placeholder"),
              );
            }),
          ),
          SizedBox(height: layout.verticalRowSpacing),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.mediumHeight,
            openOnTap: true,
            modalSize: ModalSize.fullscreen,
            modalTitle: "Model Comparison",
            child: const Text("Model Portfolio Comparison Placeholder"),
          ),
          SizedBox(height: layout.verticalRowSpacing),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.shortHeight,
            openOnTap: true,
            modalSize: ModalSize.medium,
            modalTitle: "Try Before You Mirror",
            child: Center(
              child: Text("👀 Simulate First – See how it would have performed."),
            ),
          ),
        ],
      ),
    );
  }


  Widget _desktopBuildStrategy(LayoutHelper layout) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LayoutHelper.fixedOuterScreenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.shortHeight,
            openOnTap: true,
            modalSize: ModalSize.medium,
            modalTitle: "Prompt Input",
            child: const Text("Strategy Prompt Input Placeholder"),
          ),
          SizedBox(height: layout.verticalRowSpacing),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.mediumHeight,
            openOnTap: true,
            modalSize: ModalSize.medium,
            modalTitle: "Risk & ROI Sliders",
            child: const Text("Sliders Placeholder"),
          ),
          SizedBox(height: layout.verticalRowSpacing),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.mediumHeight,
            openOnTap: true,
            modalSize: ModalSize.medium,
            modalTitle: "Token Filters",
            child: const Text("Token Filters Placeholder"),
          ),
          SizedBox(height: layout.verticalRowSpacing),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.mediumHeight,
            openOnTap: true,
            modalSize: ModalSize.large,
            modalTitle: "Backtest Results",
            child: const Text("Backtest Results Placeholder"),
          ),
          SizedBox(height: layout.verticalRowSpacing),
          WrixlCard(
            width: layout.threeColumnWidth,
            height: layout.shortHeight,
            openOnTap: true,
            modalSize: ModalSize.small,
            modalTitle: "Simulate & Save",
            child: const Text("Save CTA Placeholder"),
          ),
        ],
      ),
    );
  }



  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolios'),
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layout = LayoutHelper.fromDimensions(
              constraints.maxWidth, constraints.maxHeight);
          return TabBarView(
            controller: _tabController,
            children: [
              _mobileSection([
                "Filters",
                "Portfolio 1",
                "Portfolio 2",
                "Portfolio 3",
                "Portfolio Detail",
              ], layout),
              _mobileSection([
                "Model Portfolio 1",
                "Model Portfolio 2",
                "Model Portfolio 3",
                "Model Portfolio 4",
                "Model Comparison",
              ], layout),
              _mobileSection([
                "Prompt Input",
                "Risk & ROI Sliders",
                "Token Filters",
                "Backtest Results",
                "Simulate & Save",
              ], layout),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          _tabController.animateTo(2);
        },
        child: const Icon(Icons.add_chart_rounded),
      ),
    );
  }


  Widget _mobileSection(List<String> titles, LayoutHelper layout) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: LayoutHelper.fixedOuterScreenMargin,
        vertical: 24,
      ),
      child: Column(
        children: titles
            .map(
              (title) => Padding(
                padding: EdgeInsets.only(bottom: layout.verticalRowSpacing),
                child: WrixlCard(
                  width: layout.oneColumnWidth,
                  height: layout.mediumHeight,
                  openOnTap: true,
                  modalSize: ModalSize.medium,
                  modalTitle: title,
                  child: Text("$title Placeholder"),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
