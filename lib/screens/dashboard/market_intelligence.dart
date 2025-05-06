// lib\screens\dashboard\market_intelligence.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';

class MarketIntelligenceScreen extends StatefulWidget {
  const MarketIntelligenceScreen({super.key});

  @override
  State<MarketIntelligenceScreen> createState() => _MarketIntelligenceScreenState();
}

class _MarketIntelligenceScreenState extends State<MarketIntelligenceScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Insights'),
    Tab(text: 'Smart \$'),
    Tab(text: 'Signals'),
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
    if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
      return _buildDesktopTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Intelligence'),
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final layout = LayoutHelper.fromDimensions(constraints.maxWidth, constraints.maxHeight);
        return TabBarView(
          controller: _tabController,
          children: [
            _wrapCards(layout, _insightCards(layout)),
            _wrapCards(layout, _smartMoneyCards(layout)),
            _wrapCards(layout, _signalCards(layout)),
          ],
        );
      }),
    );
  }

  Widget _wrapCards(LayoutHelper layout, List<_CardData> cards) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: LayoutHelper.fixedOuterScreenMargin, vertical: 24),
      child: Wrap(
        spacing: layout.cardGutter,
        runSpacing: layout.verticalRowSpacing,
        children: cards
            .map((card) => WrixlCard(
                  width: card.width,
                  height: card.height,
                  modalTitle: card.modalTitle,
                  modalSize: card.modalSize,
                  openOnTap: true,
                  child: Text("${card.modalTitle} Placeholder"),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Intelligence'),
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final layout = LayoutHelper.fromDimensions(constraints.maxWidth, constraints.maxHeight);
        return TabBarView(
          controller: _tabController,
          children: [
            _columnCards(layout, _insightCards(layout)),
            _columnCards(layout, _smartMoneyCards(layout)),
            _columnCards(layout, _signalCards(layout)),
          ],
        );
      }),
    );
  }

  Widget _columnCards(LayoutHelper layout, List<_CardData> cards) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: LayoutHelper.fixedOuterScreenMargin, vertical: 24),
      child: Column(
        children: cards
            .map((card) => Padding(
                  padding: EdgeInsets.only(bottom: layout.verticalRowSpacing),
                  child: WrixlCard(
                    width: layout.oneColumnWidth,
                    height: card.height,
                    modalTitle: card.modalTitle,
                    modalSize: card.modalSize,
                    openOnTap: true,
                    child: Text("${card.modalTitle} Placeholder"),
                  ),
                ))
            .toList(),
      ),
    );
  }

  List<_CardData> _insightCards(LayoutHelper layout) => [
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.shortHeight,
          modalTitle: "Filter Bar",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.tallHeight,
          modalTitle: "Unified Feed",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.tallHeight,
          modalTitle: "Live Signal Ticker",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Capital Flow Sankey",
          modalSize: ModalSize.fullscreen,
        ),
      ];

  List<_CardData> _smartMoneyCards(LayoutHelper layout) => [
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Wallet Leaderboard",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Wallet Strategy",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.shortHeight,
          modalTitle: "Mirror Strategy",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Wallet Filters",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Live Whale Ticker",
          modalSize: ModalSize.medium,
        ),
      ];

  List<_CardData> _signalCards(LayoutHelper layout) => [
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Signal Feed",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Top Gainers / Losers",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Correlation Matrix",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Signal Tags",
          modalSize: ModalSize.medium,
        ),
      ];
}

class _CardData {
  final double width;
  final double height;
  final String modalTitle;
  final ModalSize modalSize;

  _CardData({
    required this.width,
    required this.height,
    required this.modalTitle,
    required this.modalSize,
  });
}
